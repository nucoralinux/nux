#!/bin/bash
# ══════════════════════════════════════════════════════════════
# nux installer v4.5.0
# Nucora Linux Package Manager
# Only for Debian 13 (Trixie)
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
echo "  nux installer v4.5.0"
echo "  Nucora Linux Package Manager"
echo "  Debian 13 (Trixie) only"
echo "=============================================="
echo -e "${RE}"

# Root kontrolu
if [ "$EUID" -ne 0 ]; then
    echo -e "${R}Error: Root privileges required. Run with sudo.${RE}"
    exit 1
fi

# Debian 13 kontrolu
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$VERSION_CODENAME" != "trixie" ] && [ "$VERSION_ID" != "13" ]; then
        echo -e "${Y}Warning: This installer is designed for Debian 13 (Trixie).${RE}"
        echo -e "${Y}Detected: $PRETTY_NAME${RE}"
        echo ""
        read -rp "Continue anyway? [y/N]: " answer
        if [[ ! "$answer" =~ ^[yYeE]$ ]]; then
            echo -e "${R}Cancelled.${RE}"
            exit 1
        fi
    else
        echo -e "${G}OK${RE} Debian 13 (Trixie) detected"
    fi
else
    echo -e "${Y}Warning: Cannot detect OS version.${RE}"
fi

echo ""
echo -e "${W}Checking dependencies...${RE}"
echo ""

# Bagimliliklari kontrol et
DEPS_MISSING=0
REQUIRED_CMDS=(python3 dpkg tar curl)
REQUIRED_PKGS=(python3 dpkg tar curl ca-certificates)

for cmd in "${REQUIRED_CMDS[@]}"; do
    if command -v "$cmd" >/dev/null 2>&1; then
        echo -e "  ${G}OK${RE} $cmd"
    else
        echo -e "  ${R}MISSING${RE} $cmd"
        DEPS_MISSING=1
    fi
done

echo ""

if [ "$DEPS_MISSING" -eq 1 ]; then
    echo -e "${Y}Installing missing dependencies...${RE}"
    apt-get update -qq >/dev/null 2>&1
    apt-get install -y -qq "${REQUIRED_PKGS[@]}" >/dev/null 2>&1
    echo -e "${G}OK${RE} Dependencies installed"
else
    echo -e "${G}OK${RE} All dependencies present"
fi

echo ""
echo -e "${W}Installing nux...${RE}"
echo ""

# Eski surumleri temizle
if [ -f /usr/bin/nux ]; then
    rm -f /usr/bin/nux
    echo -e "  ${Y}CLEANED${RE} /usr/bin/nux (old location)"
fi

if [ -f /usr/lib/nux/nux.py ]; then
    rm -rf /usr/lib/nux
    echo -e "  ${Y}CLEANED${RE} /usr/lib/nux (old location)"
fi

# Ana binary
install -Dm755 nux /usr/local/bin/nux
echo -e "  ${G}OK${RE} /usr/local/bin/nux"

# Nucora Linux uyumlulugu icin /usr/bin'e de symlink
if [ -L /usr/bin/nux ]; then
    rm -f /usr/bin/nux
fi
if [ ! -e /usr/bin/nux ]; then
    ln -s /usr/local/bin/nux /usr/bin/nux
    echo -e "  ${G}OK${RE} /usr/bin/nux (symlink)"
fi

# Lib dizini
mkdir -p /usr/local/lib/nux
cp nux /usr/local/lib/nux/nux.py
chmod 644 /usr/local/lib/nux/nux.py
echo -e "  ${G}OK${RE} /usr/local/lib/nux/nux.py"

# Config dizini
mkdir -p /etc/nux

# Config dosyasi yoksa olustur
if [ ! -f /etc/nux/config.json ]; then
    cat > /etc/nux/config.json <<'CFGEOF'
{
  "language": "tr",
  "theme": "default",
  "spinner": "braille",
  "install_animation": "stepped",
  "progress_style": "detailed",
  "show_stats": true
}
CFGEOF
    echo -e "  ${G}OK${RE} /etc/nux/config.json (created)"
else
    echo -e "  ${G}OK${RE} /etc/nux/config.json (kept existing)"
fi

# Repos dosyasi yoksa olustur
if [ ! -f /etc/nux/repos.json ]; then
    cat > /etc/nux/repos.json <<'REPOEOF'
{
  "repos": [
    {
      "name": "nucora-main",
      "url": "https://repo.nucoralinux.com.tr/nux",
      "enabled": true,
      "priority": 100,
      "description": "Nucora Linux Main Repository"
    }
  ]
}
REPOEOF
    echo -e "  ${G}OK${RE} /etc/nux/repos.json (created)"
else
    echo -e "  ${G}OK${RE} /etc/nux/repos.json (kept existing)"
fi

# State dizinleri
mkdir -p /var/lib/nux
mkdir -p /var/lib/nux/scripts
mkdir -p /var/lib/nux/snapshots
mkdir -p /var/cache/nux
mkdir -p /var/cache/nux/indexes
echo -e "  ${G}OK${RE} /var/lib/nux"
echo -e "  ${G}OK${RE} /var/cache/nux"

# PATH kontrolu
echo ""
echo -e "${W}Verifying installation...${RE}"
echo ""

if command -v nux >/dev/null 2>&1; then
    NUX_VER="$(nux --version 2>/dev/null || echo 'unknown')"
    echo -e "  ${G}OK${RE} nux is available: $NUX_VER"
else
    echo -e "  ${Y}NOTE${RE} nux not found in current PATH"
    echo -e "  ${Y}     Try: export PATH=/usr/local/bin:\$PATH${RE}"
    echo -e "  ${Y}     Or open a new terminal session.${RE}"
fi

# hash temizle
hash -r 2>/dev/null || true

echo ""
echo -e "${G}=============================================="
echo -e "  Installation complete!"
echo -e "==============================================${RE}"
echo ""
echo -e "${W}Quick start:${RE}"
echo ""
echo -e "  ${C}nux update${RE}              Update repository index"
echo -e "  ${C}nux search${RE} <query>      Search packages"
echo -e "  ${C}nux install${RE} <package>   Install a package"
echo -e "  ${C}nux upgrade${RE}             Upgrade packages"
echo -e "  ${C}nux doctor${RE}              System health check"
echo -e "  ${C}nux config${RE}              Configuration menu"
echo -e "  ${C}nux help${RE}                Full command list"
echo ""
echo -e "${W}Repository management:${RE}"
echo ""
echo -e "  ${C}nux repo list${RE}           List repositories"
echo -e "  ${C}nux repo add${RE} <n> <url>  Add repository"
echo -e "  ${C}nux repo remove${RE} <name>  Remove repository"
echo -e "  ${C}nux repo enable${RE} <name>  Enable repository"
echo -e "  ${C}nux repo disable${RE} <name> Disable repository"
echo ""
echo -e "${W}Requirements:${RE}"
echo -e "  ${Y}Debian 13 (Trixie) only${RE}"
echo ""
echo -e "----------------------------------------------"
echo -e "${W}Nux and Nucora are fully developed and"
echo -e "maintained by one person."
echo -e "By: Efe Enes${RE}"
echo ""
echo -e "${W}Not difficult - just time, patience,"
echo -e "and persistence.${RE}"
echo -e "----------------------------------------------"
echo ""
echo -e "${C}Website:${RE}    https://nucoralinux.com.tr"
echo -e "${C}Forum:${RE}      https://forum.nucoralinux.com.tr"
echo -e "${C}GitHub:${RE}     https://github.com/nucoralinux/nux"
echo -e "${C}Instagram:${RE}  https://instagram.com/nucoralinux"
echo ""
