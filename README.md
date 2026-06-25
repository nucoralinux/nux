<!-- Copyright (C) 2026 Nucora Linux By : Efe Enes -->
<!-- License: GNU General Public License v3.0 -->

<h1 align="center">nux</h1>
<p align="center">
  Modern Package Manager for Nucora Linux
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-4.5.0-blue">
  <img src="https://img.shields.io/badge/status-active-success">
  <img src="https://img.shields.io/badge/license-GPLv3-blue">
  <img src="https://img.shields.io/badge/platform-Debian%2013-red">
  <img src="https://img.shields.io/badge/language-Python-yellow">
  <img src="https://img.shields.io/badge/interface-CLI%20%2B%20TUI-purple">
</p>

<p align="center">
  <a href="https://nucoralinux.com.tr">Website</a> •
  <a href="https://forum.nucoralinux.com.tr">Forum</a> •
  <a href="https://repo.nucoralinux.com.tr">Repository</a> •
  <a href="https://instagram.com/nucoralinux">Instagram</a>
</p>

---

## ⚠️ Important

**nux v4.5 is currently designed for Debian 13 (Trixie) based systems.**

This release focuses on:
- safer package ownership handling
- cleaner separation between user applications and system dependencies
- multi-repository support
- interactive configuration
- stronger package inspection and health checking tools

---

## 📖 About

**nux** is the official package manager of the Nucora Linux ecosystem.

It is designed to provide a modern, clean and controlled package management experience while keeping a strong distinction between user applications, system/runtime dependencies, and protected internal tools. Unlike a simple wrapper, nux understands package classes, repository priorities, package ownership, dependency trees, and system synchronization while offering a polished terminal interface.

---

## ✨ Features & Architecture

### 🧠 Package Class System
Every package belongs to one of three classes to ensure predictable upgrades:

| Class | Description | Upgrade Behaviour |
|------|-------------|------------------|
| `app` | User-facing applications (discord, chrome, spotify, etc.) | ✅ Normal upgrade |
| `base` | Runtime / system dependencies (libraries, helpers) | ❌ Hidden from default upgrade |
| `tool` | Internal protected tools (`nux`, `nucora-*`) | ✅ Upgradeable and protected |

### 🔐 Managed Package Ownership
Every package has a `managed_by` field to prevent ownership confusion and unsafe upgrades:
- `managed_by = nux`: Package is directly controlled by nux.
- `managed_by = system`: Package belongs to the Debian / dpkg side.

### 🏥 Built-in Diagnostics & System Awareness
nux is aware of the actual Debian system state. It includes tools for package inspection (`doctor`, `why`, `tree`, `owns`, `provides`, `size`) and can scan/sync or adopt already-installed system packages.

### 📦 Snapshot / Export / Import
Supports package state portability and rollback-friendly workflows for safe system management.

### 🎨 Improved Terminal UI
Features an interactive config menu (`nux config`), Turkish/English support, animated spinners, configurable progress bars, box-drawing based sections, and package class badges.

---

## 🚀 Installation

### Requirements
- Debian 13 (Trixie)
- Python 3
- curl
- ca-certificates
- root access

### Install from GitHub

```bash
git clone https://github.com/nucoralinux/nux
cd nux
sudo bash install.sh
```
### For Remove
```bash
sudo bash uninstall.sh
```
⚡ Quick Start
After installation, update the database and install your first package:
```bash
sudo nux update
sudo nux search discord
sudo nux install discord

Useful first commands to try:
nux help
nux doctor
nux repo list
nux config
```
📚 Command Overview
Package Management
```bash
nux install <pkg...>
nux remove <pkg...>
nux purge <pkg...>
nux reinstall <pkg...>
nux upgrade
nux upgrade --apps-only
nux upgrade --full
nux update
nux local-install <file.nux>
```
Query / Inspection
```bash
nux search <query>
nux info <package>
nux list
nux list -u
nux list-all
nux depends <package>
nux rdepends <package>
nux why <package>
nux tree <package>
nux owns <file>
nux provides <name>
nux policy <package>
nux size
nux count
```
Maintenance
```bash
nux doctor
nux verify [pkg...]
nux repair
nux autoremove
nux clean
nux db-clean
nux scan-system
nux sync-system
nux adopt <package>
```
State Management
```bash
nux export
nux import <file>
nux snapshot create [name]
nux snapshot list
nux snapshot restore <name>
```
Advanced
```bash
nux pin <pkg...>
nux unpin <pkg...>
nux mark-auto <pkg...>
nux mark-manual <pkg...>
nux history
nux rollback [id]
```
🌐 Repository Management
nux supports multiple repositories with priorities. The default repository is https://repo.nucoralinux.com.tr/nux.
List repositories:
nux repo list

Add a repository:
```bash
sudo nux repo add myrepo [https://example.com/nux](https://example.com/nux)
```
Remove a repository:
```bash
sudo nux repo remove myrepo
```
Enable / Disable a repository:
```bash
sudo nux repo enable myrepo
sudo nux repo disable myrepo
```
📁 File Layout
```bash
Binary: /usr/local/bin/nux
Main library: /usr/local/lib/nux/
State / Database: /var/lib/nux/
Cache: /var/cache/nux/
Configuration: /etc/nux/config.json & /etc/nux/repos.json
```
⚙️ Configuration Files
Main config file (/etc/nux/config.json):
```bash
{
  "language": "tr",
  "theme": "default",
  "spinner": "braille",
  "install_animation": "stepped",
  "progress_style": "detailed",
  "show_stats": true
}
```
Repositories file (/etc/nux/repos.json):
```bash
{
  "repos": [
    {
      "name": "nucora-main",
      "url": "[https://repo.nucoralinux.com.tr/nux](https://repo.nucoralinux.com.tr/nux)",
      "enabled": true,
      "priority": 100,
      "description": "Nucora Linux Main Repository"
    }
  ]
}
```
📋 Changelog
v4.5.0
package class system (app / base / tool)
managed_by ownership model
safer upgrade logic
multi-repository support & repository commands
interactive config menu with Turkish / English support
new inspection tools: doctor / why / tree / owns / provides / size
state management: snapshot / export / import
system awareness: scan-system / sync-system / adopt
better terminal UI (animations, badges, box-drawing sections)

📄 License
This project is licensed under the GNU General Public License v3.0.
See the LICENSE file for the full license text.

👨‍💻 Developer
Nux and Nucora are fully developed and maintained by one person.
By: Efe Enes
All Nucora servers, repositories, forum and infrastructure are built and maintained by one person.
Not difficult — just time, patience, and persistence.

