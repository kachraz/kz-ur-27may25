#!/usr/bin/bash
# React Vite Related
clear

# Colors
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export WHITE='\033[0;37m'
export NC='\033[0m' # No Color

# Commands

h1() {
    echo -e "${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
}

# Vercel Cli Install
vercel_cli_install() {
    h1 "Vercel Cli Install via bun - https://vercel.com/docs/cli?package-manager=bun"
    co1="bun add -g vercel"
    echo -e "${GREEN}Command: ${NC}${co1}"
    eval "$co1"
}

# bun create vite
bun_create_vite() {
    h1 "bun create vite"
    co1="bun create vite@latest"
    echo -e "${GREEN}Command: ${NC}${co1}"
    eval "$co1"
}

# pnpm create vite - static
pnpm_create_vite() {
    h1 "pnpm create vite@latest"
    co1="pnpm create vite"
    echo -e "${GREEN}Command: ${NC}${co1}"
    eval "$co1"
}

# --- Execution ---
# bun_create_vite
pnpm_create_vite
# vercel_cli_install
