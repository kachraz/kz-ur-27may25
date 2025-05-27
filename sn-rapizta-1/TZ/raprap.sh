#!/usr/bin/env bash

# === USER CONFIGURATION ===
TARGETS="targets.txt" # Change this file name as needed [[9]]
THREADS=10
DATE=$(date +"%Y-%m-%d_%H%M")
OUTPUT_BASE_DIR="ctf_recon_output_$DATE"

# Colors
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export WHITE='\033[0;37m'
export NC='\033[0m' # No Color

# Functions
h1() {
    echo -e "${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
}

h2() {
    echo -e "${BLUE}==> $1${NC}"
}

info() {
    echo -e "${GREEN}[+] $1${NC}"
}

debug() {
    echo -e "${YELLOW}[*] $1${NC}"
}

error() {
    echo -e "${RED}[!] $1${NC}"
}

check_tool() {
    if ! command -v "$1" &>/dev/null; then
        error "Required tool '$1' not found. Please install it first."
        exit 1
    fi
}

setup_dirs() {
    TARGET=$1
    TARGET_DIR="$OUTPUT_BASE_DIR/$TARGET"
    mkdir -p "$TARGET_DIR"
    echo "$TARGET_DIR"
}

subdomain_enum() {
    TARGET=$1
    TARGET_DIR=$2
    h2 "Enumerating subdomains..."
    subfinder -d "$TARGET" -o "$TARGET_DIR/subdomains_subfinder.txt" -silent
    info "Subdomains saved to subdomains_subfinder.txt"
}

resolve_dns() {
    TARGET_DIR=$1
    h2 "Resolving DNS records..."
    shuffledns -l "$TARGET_DIR/subdomains_subfinder.txt" -r https://raw.githubusercontent.com/projectdiscovery/dns-resolvers/master/resolvers.txt -o "$TARGET_DIR/resolved_subdomains.txt"
    info "Resolved $(wc -l <"$TARGET_DIR/resolved_subdomains.txt") subdomains"
}

probe_web() {
    TARGET_DIR=$1
    h2 "Probing live web hosts..."
    httpx -l "$TARGET_DIR/resolved_subdomains.txt" -title -status-code -tech-detect -timeout 10 -threads $THREADS -o "$TARGET_DIR/web_servers.txt"
    info "Web hosts saved to web_servers.txt"
}

scan_ports() {
    TARGET_DIR=$1
    h2 "Scanning open ports..."
    naabu -l "$TARGET_DIR/resolved_subdomains.txt" -top-ports 100 -o "$TARGET_DIR/open_ports.txt" -silent
    info "Port scan completed"
}

scan_vulns() {
    TARGET_DIR=$1
    h2 "Running Nuclei vulnerability scans..."
    nuclei -u "https://$TARGET" -t ~/nuclei-templates -o "$TARGET_DIR/nuclei_root.txt"
    nuclei -l "$TARGET_DIR/web_servers.txt" -t ~/nuclei-templates -o "$TARGET_DIR/nuclei_subs.txt"
    info "Vulnerability scan completed"
}

discover_infra() {
    TARGET_DIR=$1
    h2 "Mapping ASN and CIDR ranges..."
    asnmap -d "$TARGET" -o "$TARGET_DIR/asn_info.txt"
    mapcidr -l "$TARGET_DIR/resolved_subdomains.txt" -o "$TARGET_DIR/cidr_ranges.txt"
    info "Infrastructure mapping complete"
}

detect_cdn() {
    TARGET_DIR=$1
    h2 "Detecting CDN usage..."
    cdncheck -l "$TARGET_DIR/resolved_subdomains.txt" >"$TARGET_DIR/cdn_check.txt"
    info "CDN detection completed"
}

detect_cloud() {
    TARGET_DIR=$1
    h2 "Detecting cloud providers..."
    cloudlist -l "$TARGET_DIR/resolved_subdomains.txt" >"$TARGET_DIR/cloud_providers.txt"
    info "Cloud provider detection completed"
}

run_scan() {
    TARGET=$1
    h1 "Starting Recon for: $TARGET"
    TARGET_DIR=$(setup_dirs "$TARGET")

    subdomain_enum "$TARGET" "$TARGET_DIR"
    resolve_dns "$TARGET_DIR"
    probe_web "$TARGET_DIR"
    scan_ports "$TARGET_DIR"
    scan_vulns "$TARGET_DIR"
    discover_infra "$TARGET_DIR"
    detect_cdn "$TARGET_DIR"
    detect_cloud "$TARGET_DIR"

    info "Scan complete for $TARGET. Output saved to $TARGET_DIR/"
}

# Main
clear
h1 "CTF Recon Automation Tool v1.1 (Project Discovery Only)"

TOOLS=("subfinder" "shuffledns" "httpx" "naabu" "nuclei" "asnmap" "mapcidr" "cdncheck" "cloudlist")
for TOOL in "${TOOLS[@]}"; do
    check_tool "$TOOL"
done

if [ ! -f "$TARGETS" ]; then
    error "Targets file '$TARGETS' not found!"
    exit 1
fi

info "Reading targets from file: $TARGETS" [[4]]
while read -r DOMAIN; do
    [[ -z "$DOMAIN" ]] && continue
    run_scan "$DOMAIN"
done <"$TARGETS"

h1 "All scans completed. Results saved in $OUTPUT_BASE_DIR/"
