# git-sync - Reset and pull all Git repositories in a folder

![Version](https://img.shields.io/badge/Version-2.0.1-blue?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)
[![CIAO](https://img.shields.io/badge/Philosophy-CIAO%20(Caution%20%E2%80%A2%20Intentional%20%E2%80%A2%20Anti--fragile%20%E2%80%A2%20Over--engineered)-purple.svg)](https://github.com/cloudgen/ciao)
[![Stars](https://img.shields.io/github/stars/cloudgen/git-sync?style=flat-square)](https://github.com/cloudgen/git-sync)
[![Shell](https://img.shields.io/badge/Shell-POSIX%20sh-orange?style=flat-square)]()

**You run `git-sync` on a folder of project checkouts.** For each **direct** child that is a Git repository, it resets that child to `HEAD` and pulls. One POSIX `/bin/sh` file. No extra packages. You can install it with `curl | sh`.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | You name a directory of checkouts. The program does **not** walk nested folders. | `git-sync sync ~/projects` |
| The other role | Each child’s Git remote and branch (defaults `origin` / `main`). | `GS_REMOTE` / `GS_BRANCH` |
| Not this | A recursive monorepo crawler, a merge UI, or a Git hosting API. | Nested `vendor/.git` is skipped |

| Includes | Excludes |
|----------|----------|
| Direct children with `.git` | Nested repos under those children |
| `git reset --hard HEAD` then `git pull` | Conflict resolution, multi-remote strategy |
| Install / update / remove of **this** program | Changing the computer as root for domain work |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Sync a folder | Only **direct** children with `.git` are reset and pulled. Nested clones are left alone. | `git-sync sync ~/projects` |
| Install for yourself | No arguments means install or re-check install — not a sync, and not help. | `curl -fsSL https://raw.githubusercontent.com/cloudgen/git-sync/main/git-sync \| sh` |

---

## Features

- Scans **direct** subfolders for `.git` (not recursive)
- Safe `git reset --hard HEAD` then `git pull` (override remote/branch with `GS_REMOTE` / `GS_BRANCH`)
- Path free-token: `git-sync ~/projects` is the same as `git-sync sync ~/projects`
- Self-install, self-update, and self-uninstall with an automatic companion checksum
- Multi-shell PATH support (bash, zsh, fish)
- `--json` and `--quiet` modes
- User install (`~/.local/bin`) and root install (`/usr/local/bin`)
- Built with **[CIAO](https://github.com/cloudgen/ciao)** (Caution • Intentional • Anti-fragile • Over-protect)

---

## Quick Installation

### Standard one-liner

```bash
curl -fsSL https://raw.githubusercontent.com/cloudgen/git-sync/main/git-sync | sh
```

Elevated (when you intend a system-wide install):

```bash
curl -fsSL https://raw.githubusercontent.com/cloudgen/git-sync/main/git-sync | sudo sh
```

On Termux, Git Bash, or Windows Command Prompt, install as **this login** (no `sudo curl | sh`). Admin privilege and a dedicated system user are unused on that class of command line.

**Integrity (SHA-256):** when `CHECKSUM` is unset, install and self-update **automatically** fetch `https://raw.githubusercontent.com/cloudgen/git-sync/main/git-sync.sha256` (same origin as the script). Human mode is designed to show the companion **link**, expected **value**, and **result**.

| Companion outcome | Behavior |
|-------------------|----------|
| Sidecar present and digest **matches** | Continue |
| Sidecar present and digest **mismatches** | Abort |
| Sidecar **missing** | Warn and continue |

In-repo companion file: `git-sync.sha256` (bare SHA-256 hex of `./git-sync`).

### Advanced / CI pin (optional)

An env pin is **not** required for a normal install. Use it only when you already trust a digest from another channel:

```bash
CHECKSUM="<64-hex-sha256-of-git-sync>" \
  curl -fsSL https://raw.githubusercontent.com/cloudgen/git-sync/main/git-sync | sh
```

Same-origin `CHECKSUM=$(curl …sha256)` is **not** higher assurance than the automatic companion.

**Current product version:** **2.0.1**

---

## Usage

```bash
# Domain (sync subfolder repos)
git-sync sync                 # Sync direct child repos under .
git-sync sync ~/projects      # Sync under ~/projects/
git-sync ~/projects           # Path free-token → same as sync

# Lifecycle of this program
git-sync                      # Empty argv: install-ensure (curl|sh contract)
git-sync help                 # Show help
git-sync version              # Show version
git-sync about                # Diagnostics (install paths, cache folder, persistence folder)
git-sync self-update          # Update from the channel
git-sync self-uninstall       # Remove
git-sync --json sync .        # Machine-readable domain output
```

Domain env (optional): `GS_REMOTE` (default `origin`), `GS_BRANCH` (default `main`).

Channel env: `REPO_USER` / `REPO_NAME` / `SCRIPT_URL`. Help and about **do not** list `CHECKSUM`.

---

## Examples

```bash
# Sync every Git checkout sitting directly under ~/work
git-sync sync ~/work

# Same thing with a path token (no `sync` word)
git-sync ~/work

# JSON summary (stdout is one object; git chatter is not mixed in)
git-sync --json sync ~/work

# See this login’s cache folder and persistence folder
git-sync about
```

A missing start directory fails closed (`no_start_dir` in JSON). Zero matching children is success with a warning (`found=0`), not a hard failure. Nested repos under a child are **not** scanned.

---

## Platform Compatibility

| Surface | Status |
|---------|--------|
| POSIX `/bin/sh` (dash, bash-as-sh, BusyBox ash) | Supported — primary |
| Linux with `git`, `curl` or `wget`, `sha256sum`, `mktemp` | Supported |
| macOS `/bin/sh` with GNU-compatible `sha256sum` or equivalent | Best-effort |
| Termux / Git Bash / Windows Command Prompt | **Normal user privilege only** — no `sudo curl \| sh`, no dedicated system user |
| Recursive monorepo / submodule walk | Not this product |

---

## Related Projects

- [selfmanaged](https://github.com/cloudgen/selfmanaged) — Type 0 bootstrap this product specializes from (A→B; do not reverse-copy)
- [CIAO](https://github.com/cloudgen/ciao) — Defensive philosophy (Caution • Intentional • Anti-fragile • Over-protect)

---

## Contributing

Keep the ship unit a **single** POSIX `/bin/sh` file (`./git-sync`) so `curl | sh` still works. Run `sh tests/run.sh` before a change lands. Product law lives under `docs/requirements/` (registry `docs/requirements/index.md`). Do not overwrite the bootstrap origin `./selfmanaged` from this product.

Protection Zones and `!!! DO NOT MODIFY OR SIMPLIFY !!!` blocks stay unless there is an explicit redesign.

---

## License

[MIT](LICENSE.md) — Copyright (c) 2026 Wong Chun Fai, aka: Cloudgen (`cloudgen.wong@gmail.com`).

---

## Last Update

2026-09-06 — **2.0.1**: human-readable README and requirements; cache folder + persistence folder; coding-style product law; `GS_REMOTE` / `GS_BRANCH` on help.
