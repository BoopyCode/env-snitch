#!/usr/bin/env bash
# Env Snitch - The tattletale for your environment variables
# When your app fails with "undefined is not a function" but really means "DB_PASSWORD is empty"

# Colors for dramatic effect (because debugging should be theatrical)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color (like your app without proper env vars)

# The snitching begins
snitch() {
    echo -e "${YELLOW}🔍 Env Snitch is on the case...${NC}"
    echo -e "${YELLOW}Looking for clues in your environment...${NC}"
    echo ""
    
    # Check if we have a suspect list
    if [ $# -eq 0 ]; then
        echo -e "${RED}🚨 No suspects provided! Give me variable names to investigate.${NC}"
        echo "Usage: $0 VAR1 VAR2 VAR3"
        echo "Example: $0 DATABASE_URL API_KEY SECRET_TOKEN"
        exit 1
    fi
    
    local missing=0
    local found=0
    
    # Interrogate each suspect
    for var in "$@"; do
        if [ -z "${!var}" ]; then
            echo -e "${RED}❌ $var: MISSING${NC} (Last seen: nowhere)"
            missing=$((missing + 1))
        else
            # Show first few chars only (we're snitches, not exhibitionists)
            local value="${!var}"
            local preview="${value:0:20}"
            if [ ${#value} -gt 20 ]; then
                preview="${preview}..."
            fi
            echo -e "${GREEN}✅ $var: PRESENT${NC} (Value: $preview)"
            found=$((found + 1))
        fi
    done
    
    echo ""
    echo "=== SNITCH REPORT ==="
    echo -e "Found: ${GREEN}$found${NC} | Missing: ${RED}$missing${NC}"
    
    if [ $missing -gt 0 ]; then
        echo -e "${RED}🚨 CASE NOT SOLVED: Some variables are playing hide-and-seek!${NC}"
        echo "Check your .env file, deployment config, or ask your cat who sat on the keyboard."
        exit 1
    else
        echo -e "${GREEN}✅ CASE CLOSED: All variables accounted for!${NC}"
        echo "Your app might still fail, but at least it won't be the environment's fault."
        exit 0
    fi
}

# Only run if called directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    snitch "$@"
fi
