#!/usr/bin/env bash

# === USER CONFIGURATION ===
TARGET="cantina.xyz"
THREADS=10
DATE=$(date +"%Y-%m-%d_%H%M")
OUTPUT_BASE_DIR="recursive_recon_output_$DATE"

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

setup_dirs() {
    TARGET=$1
    TARGET_DIR="$OUTPUT_BASE_DIR/$TARGET"
    mkdir -p "$TARGET_DIR"
    echo "$TARGET_DIR"
}

run_domain_recon() {
    TARGET=$1
    h1 "Starting Recon for: $TARGET"
    TARGET_DIR=$(setup_dirs "$TARGET")

    # Subdomain Enumeration
    h2 "Enumerating subdomains for $TARGET"
    if ! subfinder -d "$TARGET" -o "$TARGET_DIR/subdomains.txt" -silent; then
        error "Subfinder failed for $TARGET"
        return 1
    fi
    info "Subdomains saved to $TARGET_DIR/subdomains.txt"

    # DNS Resolution
    h2 "Resolving DNS records..."
    if ! dnsx -l "$TARGET_DIR/subdomains.txt" -r "8.8.8.8,8.8.4.4" -o "$TARGET_DIR/resolved_subdomains.txt" -silent; then
        error "Dnsx failed for $TARGET"
        return 1
    fi
    info "Resolved $(wc -l <"$TARGET_DIR/resolved_subdomains.txt") subdomains"

    # Web Probing
    h2 "Probing live web hosts..."
    if ! httpx -list "$TARGET_DIR/resolved_subdomains.txt" -title -status-code -tech-detect -threads $THREADS -o "$TARGET_DIR/web_servers.txt"; then
        error "Httpx failed for $TARGET"
        return 1
    fi
    info "Web hosts saved to web_servers.txt"

    # Port Scanning
    h2 "Scanning open ports..."
    if ! naabu -list "$TARGET_DIR/resolved_subdomains.txt" -top-ports 100 -o "$TARGET_DIR/open_ports.txt"; then
        error "Naabu failed for $TARGET"
        return 1
    fi
    info "Port scan completed"

    # CDN Detection
    h2 "Detecting CDN usage..."
    if ! cdncheck -list "$TARGET_DIR/resolved_subdomains.txt" -o "$TARGET_DIR/cdn_check.txt"; then
        error "Cdncheck failed for $TARGET"
        return 1
    fi
    info "CDN detection completed"

    # Cloud Provider Detection
    h2 "Detecting cloud providers..."
    if ! cloudlist -list "$TARGET_DIR/resolved_subdomains.txt" -o "$TARGET_DIR/cloud_providers.txt"; then
        error "Cloudlist failed for $TARGET"
        return 1
    fi
    info "Cloud provider detection completed"

    # Infrastructure Mapping
    h2 "Mapping ASN and CIDR ranges..."
    if ! asnmap -d "$TARGET" -o "$TARGET_DIR/asn_info.txt"; then
        error "Asnmap failed for $TARGET"
        return 1
    fi
    if ! mapcidr -list "$TARGET_DIR/resolved_subdomains.txt" -o "$TARGET_DIR/cidr_ranges.txt"; then
        error "Mapcidr failed for $TARGET"
        return 1
    fi
    info "Infrastructure mapping complete"

    # Vulnerability Scan
    h2 "Running Nuclei vulnerability scans..."
    if ! nuclei -u "https://$TARGET" -templates ~/nuclei-templates -o "$TARGET_DIR/nuclei_root.txt"; then
        error "Nuclei failed for root domain $TARGET"
        return 1
    fi
    if ! nuclei -list "$TARGET_DIR/web_servers.txt" -templates ~/nuclei-templates -o "$TARGET_DIR/nuclei_subs.txt"; then
        error "Nuclei failed for subdomains of $TARGET"
        return 1
    fi
    info "Vulnerability scan completed"

    info "Recon completed for $TARGET in $TARGET_DIR/"

    # Return subdomains file path
    echo "$TARGET_DIR/resolved_subdomains.txt"
}

run_recursive_recon() {
    SUBDOMAINS_FILE=$1

    while read -r SUBDOMAIN; do
        [[ -z "$SUBDOMAIN" ]] && continue

        h1 "Recursive Recon for Subdomain: $SUBDOMAIN"
        SUB_TARGET_DIR="$OUTPUT_BASE_DIR/$SUBDOMAIN"
        mkdir -p "$SUB_TARGET_DIR"

        # Re-run key recon steps on each subdomain
        h2 "Resolving DNS for $SUBDOMAIN"
        if ! echo "$SUBDOMAIN" | dnsx -silent -o "$SUB_TARGET_DIR/dns_resolve.txt"; then
            error "Dnsx failed for $SUBDOMAIN"
            continue
        fi

        h2 "Web probing for $SUBDOMAIN"
        if ! echo "$SUBDOMAIN" | httpx -title -status-code -tech-detect -o "$SUB_TARGET_DIR/web_info.txt"; then
            error "Httpx failed for $SUBDOMAIN"
            continue
        fi

        h2 "Port scanning for $SUBDOMAIN"
        if ! echo "$SUBDOMAIN" | naabu -top-ports 100 -o "$SUB_TARGET_DIR/ports.txt"; then
            error "Naabu failed for $SUBDOMAIN"
            continue
        fi

        h2 "Vulnerability scan for $SUBDOMAIN"
        if ! echo "$SUBDOMAIN" | nuclei -templates ~/nuclei-templates -o "$SUB_TARGET_DIR/nuclei_vulns.txt"; then
            error "Nuclei failed for $SUBDOMAIN"
            continue
        fi

        info "Recursive recon completed for $SUBDOMAIN"

    done < <(grep -v "$TARGET" "$SUBDOMAINS_FILE") # Skip root domain line
}

# Main
clear
h1 "Recursive Reconnaissance Tool v1.0 (Project Discovery Only)"

TOOLS=("subfinder" "dnsx" "httpx" "naabu" "cdncheck" "cloudlist" "asnmap" "mapcidr" "nuclei")
for TOOL in "${TOOLS[@]}"; do
    if ! command -v "$TOOL" &>/dev/null; then
        error "Required tool '$TOOL' not found."
        exit 1
    fi
done

# Step 1: Initial recon on root domain
INITIAL_SUBDOMAINS=$(run_domain_recon "$TARGET")

# Step 2: Recursive recon on all discovered subdomains
if [ -f "$INITIAL_SUBDOMAINS" ] && [ "$(wc -l <"$INITIAL_SUBDOMAINS")" -gt 0 ]; then
    info "Subdomains found. Running recursive recon..."
    run_recursive_recon "$INITIAL_SUBDOMAINS"
else
    error "No additional subdomains found for recursive recon."
fi

h1 "All scans completed. Results saved in $OUTPUT_BASE_DIR/"
