#!/bin/bash

set -euo pipefail

# =========================
# Colors
# =========================
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

# =========================
# Functions
# =========================

usage() {
    echo "Usage: $0 <nginx_log_file>"
    exit 1
}

check_file() {
    if [ ! -f "$1" ]; then
        echo -e "${RED}ERROR:${RESET} File not found!"
        exit 1
    fi

    if [ ! -r "$1" ]; then
        echo -e "${RED}ERROR:${RESET} File not readable!"
        exit 1
    fi
}

total_requests() {
    wc -l < "$1"
}

top_ips() {
    awk '{print $1}' "$1" | sort | uniq -c | sort -nr
}

status_codes() {
    awk '{print $9}' "$1" | sort | uniq -c | sort -nr
}

endpoints() {
    awk -F '"' '{print $2}' "$1" | awk '{print $2}' | sort | uniq -c | sort -nr
}

suspicious_ips() {
    local threshold=50
    echo -e "${RED}🚨 Suspicious IPs (>${threshold} requests):${RESET}"
    awk '{print $1}' "$1" | sort | uniq -c | sort -nr | awk -v t="$threshold" '$1 > t'
}

error_rate() {
    local file=$1

    total=$(wc -l < "$file")
    errors=$(awk '$9 ~ /^[45]/' "$file" | wc -l)

    if [ "$total" -eq 0 ]; then
        echo "No requests found"
        return
    fi

    rate=$(awk -v e="$errors" -v t="$total" 'BEGIN { printf "%.2f", (e/t)*100 }')

    printf "Total: %s | Errors: %s | Error Rate: %s%%\n" "$total" "$errors" "$rate"
}

# =========================
# Main
# =========================

if [ $# -ne 1 ]; then
    usage
fi

LOGFILE=$1

check_file "$LOGFILE"

# 📁 Ensure reports directory exists
mkdir -p reports

REPORT="reports/nginx_report_$(date +%Y-%m-%d_%H-%M-%S).txt"

{
echo "==============================="
echo -e "${BLUE}   NGINX LOG ANALYZER${RESET}"
echo " Date: $(date)"
echo "==============================="
echo

echo "📊 Total Requests:"
total_requests "$LOGFILE"
echo

echo "🌍 Top IPs:"
top_ips "$LOGFILE" | head -10
echo

echo "📌 Status Codes:"
status_codes "$LOGFILE"
echo

echo "🔗 Top Endpoints:"
endpoints "$LOGFILE" | head -10
echo

echo "⚠️ Error Rate:"
error_rate "$LOGFILE"
echo

suspicious_ips "$LOGFILE"

} | tee "$REPORT"

echo
echo -e "${GREEN}✅ Report saved to:${RESET} $REPORT"
