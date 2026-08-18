# git-sync

[![Version](https://img.shields.io/badge/Version-2.0.0-blue?style=flat-square)](CHANGELOG.md)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE.md)
[![CIAO](https://img.shields.io/badge/Philosophy-CIAO%20(Caution%20%E2%80%A2%20Intentional%20%E2%80%A2%20Anti--fragile%20%E2%80%A2%20Over--engineered)-purple.svg)](https://github.com/cloudgen/ciao)
[![Shell](https://img.shields.io/badge/Shell-POSIX%20sh-orange?style=flat-square)]()

**Simple, defensive, self-installing tool that resets and pulls all Git repositories in a folder.**

One single POSIX shell file. Zero dependencies. Perfect `curl | sh` experience.

Specialized from **[selfmanaged](https://github.com/cloudgen/selfmanaged)** Type 0 architecture (A→B): full install / self-update / self-uninstall lifecycle plus a `sync` domain for subfolder repos.

---

## Features

- Scans **direct** subfolders for `.git` repositories (not recursive)
- Performs safe `git reset --hard HEAD` + `git pull origin main` (override via `GS_REMOTE` / `GS_BRANCH`)
- Full self-install / self-update / self-uninstall with automatic companion checksum
- Multi-shell PATH support (bash, zsh, fish)
- `--json` and `--quiet` modes
- Root and user installation support
- Built with strict **[CIAO](https://github.com/cloudgen/ciao)** principles

---

## Installation

### Standard One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/cloudgen/git-sync/main/git-sync | sh
```

Elevated (when you intend a system-wide install):

```bash
curl -fsSL https://raw.githubusercontent.com/cloudgen/git-sync/main/git-sync | sudo sh
```

**Integrity (SHA-256):** when `CHECKSUM` is unset, install/self-update **automatically** fetches `https://raw.githubusercontent.com/cloudgen/git-sync/main/git-sync.sha256` (same origin as the script).

| Companion outcome | Behavior |
|-------------------|----------|
| Sidecar present and digest **matches** | Continue |
| Sidecar present and digest **mismatches** | Abort |
| Sidecar **missing** | Warn and continue |

Optional strict pin:

```bash
CHECKSUM="e6b50decf60e31275e7931c91bbd3d76e5eba2908fd6f32a25902a024b52ab49" \
  curl -fsSL https://raw.githubusercontent.com/cloudgen/git-sync/main/git-sync | sh
```

> **Current product version**: **2.0.0** (bootstrap architecture from selfmanaged 1.2.1)

---

## Usage

```bash
# Domain (sync subfolder repos)
git-sync sync                 # Sync direct child repos under .
git-sync sync ~/projects      # Sync under ~/projects/
git-sync ~/projects           # Path free-token → same as sync

# Type 0 lifecycle
git-sync                      # Empty argv: install-ensure (curl|sh contract)
git-sync help                 # Show help
git-sync version              # Show version
git-sync about                # Diagnostics
git-sync self-update          # Update
git-sync self-uninstall       # Remove
git-sync --json sync .        # Machine-readable domain output
```

---

## Development Workflow (ShellParser)

This project is maintained using **[ShellParser](https://github.com/cloudgen/ShellParser)** — allowing safe modular development while keeping a perfect single-file `curl | sh` experience.

See full instructions in [`docs/ShellParser.skill`](docs/ShellParser.skill).

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

- [`docs/ShellParser.skill`](docs/ShellParser.skill) — Official development guide for AI & humans
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

**License**: [MIT](LICENSE.md)
