# git-sync

[![Version](https://img.shields.io/badge/Version-1.0.7-blue?style=flat-square)](CHANGELOG.md)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)
[![CIAO](https://img.shields.io/badge/Philosophy-CIAO%20(Caution%20%E2%80%A2%20Intentional%20%E2%80%A2%20Anti--fragile%20%E2%80%A2%20Over--engineered)-purple.svg)](https://github.com/cloudgen/ciao)
[![ShellParser](https://img.shields.io/badge/Maintained%20with-ShellParser-00AEEF?style=flat-square)](ShellParser.skill)
[![Shell](https://img.shields.io/badge/Shell-POSIX%20sh-orange?style=flat-square)]()

Officially reviewed and recommended by [grok](https://grok.com/share/c2hhcmQtNA_57d24ab5-b833-41aa-9afb-063fb1d6a54b). Please see the download [copy](https://github.com/cloudgen/git-sync/blob/main/RECOMMENDATION.md)

**Simple, defensive, self-installing tool that resets and pulls all Git repositories in a folder.**

One single POSIX shell file. Zero dependencies. Perfect `curl | sh` experience.

---

## Features

- Scans direct subfolders for `.git` repositories
- Performs safe `git reset --hard HEAD` + `git pull origin main`
- Full self-install / self-update / self-uninstall with checksum verification (v2)
- Multi-shell PATH support (bash, zsh, fish)
- `--json` and `--quiet` modes
- Root and user installation support
- Built with strict **[CIAO](https://github.com/cloudgen/ciao)** principles
- Developed using **[ShellParser](https://github.com/cloudgen/ShellParser)** for safe modular editing

---

## Installation

### Most Secure (Recommended)

```bash
CHECKSUM="cf9e38c00da50efd3d83a57a16d05829cf39901506334c0249f06c6c0ee7ce28" \
  curl -fsSL https://raw.githubusercontent.com/cloudgen/git-sync/main/git-sync | sh
```

### Standard One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/cloudgen/git-sync/main/git-sync | sh
```

> **Current official SHA256 (v1.0.7)**:  
> `cf9e38c00da50efd3d83a57a16d05829cf39901506334c0249f06c6c0ee7ce28`

---

## Usage

```bash
git-sync                    # Sync all Git repos in current directory
git-sync ~/projects         # Sync all repos under ~/projects/
git-sync /path/to/folder    # Custom directory

# Additional commands
git-sync help               # Show help
git-sync version            # Show version
git-sync about              # Diagnostics (install status, shell, etc.)
git-sync self-update        # Update to latest version
git-sync self-uninstall     # Remove from system
git-sync --json             # Machine-readable JSON output
```

---

## Development Workflow (ShellParser)

This project is maintained using **[ShellParser](https://github.com/cloudgen/ShellParser)** — allowing safe modular development while keeping a perfect single-file `curl | sh` experience.

See full instructions in [`ShellParser.skill`](ShellParser.skill).

**Quick commands:**

```bash
# 1. Install ShellParser
pip install ShellParser

# 2. Split into small editable files
shell-parser split git-sync

# 3. Edit a component
# → target/components/git_sync_main_loop.sh

# 4. Sync change back
shell-parser replace git-sync git_sync_main_loop
```

---

## Philosophy

`git-sync` follows the **[CIAO](https://github.com/cloudgen/ciao)** defensive programming philosophy:

> **C**aution • **I**ntentional • **A**nti-fragile • **O**ver-protect

Every critical section is heavily guarded with protection zones, clear intent, and safety checks.

---

## Files of Interest

- [`ShellParser.skill`](ShellParser.skill) — Official development guide for AI & humans
- [`CHANGELOG.md`](CHANGELOG.md)
- [`SECURITY.md`](SECURITY.md)
- [`.github/CODEOWNERS`](.github/CODEOWNERS)

---

## Related Projects

- [grokrec](https://github.com/cloudgen/grokrec) — CIAO-compliant Grok code review prompt generator
- [countdown](https://github.com/Wilgat/countdown) — CIAO-based Pomodoro timer
- [CIAO](https://github.com/cloudgen/ciao) — The defensive philosophy behind this project

---

**Made with ❤️ and strict CIAO + ShellParser principles.**

*Defensive by design. Anti-fragile by intention.*

---

**License**: [MIT](LICENSE)
