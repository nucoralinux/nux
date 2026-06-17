#!/bin/bash
# ══════════════════════════════════════════════════════════════
# nux uninstaller v4.5.0
# Nucora Linux Package Manager
#
# Copyright (C) 2026 Nucora Linux
# By: Efe Enes
# License: GNU General Public License v3.0
# ══════════════════════════════════════════════════════════════

set -e

R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
C='\033[1;36m'
W='\033[1;37m'
RE='\033[0m'

echo -e "${C}"
echo "=============================================="
echo "  nux uninstaller v4.5.0"
echo "  Nucora Linux Package Manager"
echo "=============================================="
echo -e "${RE}"

# Root kontrolu
if [ "$EUID" -ne 0 ]; then
    echo -e "${R}Error: Root privileges required. Run with sudo.${RE}"
    exit 1
fi

echo -e "${W}This will remove nux from your system.${RE}"
echo ""
echo -e "${W}The following will be removed:${RE}"
echo -e "  ${R}-${RE} /usr/local/bin/nux"
echo -e "  ${R}-${RE} /usr/local/lib/nux/"
echo ""
echo -e "${W}The following will be kept:${RE}"
echo -e "  ${G}+${RE} /etc/nux/              (configuration)"
echo -e "  ${G}+${RE} /var/lib/nux/           (database, history, snapshots)"
echo -e "  ${G}+${RE} /var/cache/nux/         (cache)"
echo -e "  ${G}+${RE} /var/log/nux.log        (log)"
echo ""

read -rp "$(echo -e "${Y}Continue with removal? [y/N]: ${RE}")" answer
if [[ ! "$answer" =~ ^[yYeE]$ ]]; then
    echo -e "${G}Cancelled.${RE}"
    exit 0
fi

echo ""
echo -e "${W}Removing nux...${RE}"
echo ""

# Ana binary
if [ -f /usr/local/bin/nux ]; then
    rm -f /usr/local/bin/nux
    echo -e "  ${G}OK${RE} Removed /usr/local/bin/nux"
else
    echo -e "  ${Y}SKIP${RE} /usr/local/bin/nux (not found)"
fi

# Eski konum
if [ -f /usr/bin/nux ]; then
    rm -f /usr/bin/nux
    echo -e "  ${G}OK${RE} Removed /usr/bin/nux (old location)"
fi

# Lib dizini
if [ -d /usr/local/lib/nux ]; then
    rm -rf /usr/local/lib/nux
    echo -e "  ${G}OK${RE} Removed /usr/local/lib/nux/"
else
    echo -e "  ${Y}SKIP${RE} /usr/local/lib/nux/ (not found)"
fi

# Eski lib konum
if [ -d /usr/lib/nux ]; then
    rm -rf /usr/lib/nux
    echo -e "  ${G}OK${RE} Removed /usr/lib/nux/ (old location)"
fi

# hash temizle
hash -r 2>/dev/null || true

echo ""
echo -e "${G}=============================================="
echo -e "  nux has been removed."
echo -e "==============================================${RE}"
echo ""
echo -e "${W}Your configuration and data have been kept:${RE}"
echo ""
echo -e "  ${C}/etc/nux/${RE}              Configuration files"
echo -e "  ${C}/var/lib/nux/${RE}           Database, history, snapshots"
echo -e "  ${C}/var/cache/nux/${RE}         Cached packages and indexes"
echo -e "  ${C}/var/log/nux.log${RE}        Log file"
echo ""
echo -e "${W}To completely remove all nux data:${RE}"
echo ""
echo -e "  ${Y}sudo rm -rf /etc/nux /var/lib/nux /var/cache/nux /var/log/nux.log${RE}"
echo ""
echo -e "${W}To reinstall:${RE}"
echo ""
echo -e "  ${C}git clone https://github.com/nucoralinux/nux.git${RE}"
echo -e "  ${C}cd nux${RE}"
echo -e "  ${C}sudo bash install.sh${RE}"
echo ""
echo -e "----------------------------------------------"
echo -e "${W}Nux and Nucora are fully developed and"
echo -e "maintained by one person."
echo -e "By: Efe Enes${RE}"
echo -e "----------------------------------------------"
echo ""
