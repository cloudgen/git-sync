**file**: docs/requirements/requirement-shell-cli-storage.md
**Requirement-ID**: `RQ-SHELL-CLI-STORAGE`
**Status**: Active (Version 1.1.0 – cache folder **and** persistence folder)
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **project Single Source of Truth** for **shell CLI storage** of the **git-sync** POSIX `/bin/sh` CLI. **Storage** means **two** classes, not cache alone:

| Class | Role | Live path shape |
|-------|------|-----------------|
| **Cache folder** | Volatile scratch / temps / install staging | Preferred `/dev/shm/cache/cache-git-sync`; then `/tmp/cache/cache-git-sync`; then `${XDG_CACHE_HOME}/cache-git-sync` |
| **Persistence folder** | Durable per-user app data | `${HOME}/.local/git-sync` |

It owns path **shapes**, central resolvers, `app_main` wire, and about diagnostics for **both** classes.

**Scope:** Cache resolve priority; persistence folder create-before-return; isolation; `util_resolve_storage` / `util_resolve_persistent_storage` contract; `EFFECTIVE_STORAGE_DIR` / `PERSISTENT_STORAGE_DIR` / `TMPDIR` export; about human + JSON fields.

**Out of scope (cited, not re-owned):** Binary install paths (`USER_BIN` / `GLOBAL_BIN` = `${HOME}/.local/bin`); domain project trees (`requirement-domain-git-sync`); companion checksum; PATH shell-rc; Type 1 host deposit (`/var/…`); secrets under `${HOME}/.config/git-sync`.

---

### 1.1 Human-facing

**In one sentence:** You run `git-sync about` to see **this login’s cache folder** (scratch) and **persistence folder** (durable files under `${HOME}/.local/git-sync`).

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | Your home and your scratch dirs. The program creates them for you; it does not mix them with another login. | `git-sync about` |
| The other role | Install location `${HOME}/.local/bin` is **not** the persistence folder. | `USER_BIN` |
| Not this file | Git working trees you `sync` stay in the folders you name. This file does not pick those trees. | `git-sync sync .` |

| Includes | Excludes |
|----------|----------|
| Cache folder (preferred RAM, then `/tmp`, then user cache) | The install binary directory `${HOME}/.local/bin` |
| Persistence folder `${HOME}/.local/git-sync` | Domain repo paths; `/var/…` host deposit |
| `about` lines that name both folders | Treating scratch as durable data |

| Surface | What you open | What for |
|---------|---------------|----------|
| `./git-sync` | ship unit | live resolve + create |
| `git-sync about` | command | Cache folder + Persistence folder |
| `git-sync --json about` | command | `cache_preferred`, `cache_fallback`, `persistence_storage`, `effective_storage` |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Inspect folders | `about` prints the **cache folder** (scratch) and the **persistence folder** (durable). Scratch is volatile first. Durable data lives under `${HOME}/.local/git-sync`, not next to the installed binary. | `git-sync about` |
| Machine check | JSON names both classes. `effective_storage` is the **live** cache root this run created. | `git-sync --json about` |

---

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Two storage classes (mandatory)

1. Product storage **MUST** name **both** a **cache folder** and a **persistence folder**. Naming cache alone is incomplete law.  
2. Scratch, temps, and `mktemp` leaves **MUST** use the **cache folder**.  
3. Durable per-user app data **MUST** use the **persistence folder**.  
4. **MUST NOT** store scratch in the persistence folder when a cache root is available.  
5. **MUST NOT** use `${HOME}/.local/bin` as the persistence folder (that is `USER_BIN`).  
6. **MUST NOT** use `${HOME}/.local/share/git-sync` as this product’s persistence shape.  
7. **MUST NOT** use a Type 1 `/var/…` deposit as this product’s persistence folder.

### 2.2 Single cache resolver SSOT

1. **MUST** keep **one** authoritative cache-resolve helper: **`util_resolve_storage`**.  
2. New code that needs a product scratch/cache **root** **MUST** call `util_resolve_storage` (or `mktemp` under a path it returned) — **MUST NOT** introduce parallel hard-coded `/tmp/git-sync` dumps.  
3. Resolver **MUST** print the chosen directory path on **stdout** for `$(util_resolve_storage)` capture (data return — not product UI).  
4. User-visible failure about storage **MUST** use Output SSOT (`out_die` / structured error as mode requires) — peer `requirement-shell-output-requirements`.

Path helpers (class B stdout) **MUST** exist:

| Helper | Prints |
|--------|--------|
| `util_preferred_cache_dir` | `/dev/shm/cache/cache-${APP_NAME}` |
| `util_fallback_cache_dir` | `${XDG_CACHE_HOME}/cache-${APP_NAME}` |
| `util_persistent_storage_dir` | `${HOME}/.local/${APP_NAME}` |
| `util_resolve_persistent_storage` | Creates the persistence folder, confirms writable, prints it (fail closed) |
| `util_resolve_storage` | Creates the chosen **cache folder**, prints it (fail closed) |

### 2.3 Live cache resolve priority (normative for this product)

First match that is available and writable:

| Order | Condition | Path shape |
|-------|-----------|------------|
| 1 | `/dev/shm` exists and is writable | `/dev/shm/cache/cache-${APP_NAME}` |
| 2 | `/tmp` is writable | `/tmp/cache/cache-${APP_NAME}` |
| 3 | Fallback | `STORAGE_DIR` (default `${XDG_CACHE_HOME}/cache-${APP_NAME}`, env-overridable) |

**MUST NOT** use `/dev/shm/${APP_NAME}` or `/dev/shm/${APP_NAME}-${USERNAME}` as the preferred cache — those look like ram-drive **project** folders. Preferred **MUST** be `/dev/shm/cache/cache-${APP_NAME}`.

Create `/dev/shm/cache` and `/tmp/cache` (prefer mode **1777**) so other logins can add sibling `cache-<app>` leaves. If the preferred leaf exists but is **not writable**, fall through.

**Create before return:** for the **chosen** cache tier, the resolver **MUST** `mkdir -p` the root, then print the path. If create fails → **MUST** fail closed via `out_die`. **MUST NOT** return a path without creating it.

### 2.4 Persistence folder (normative)

1. Persistence folder **MUST** be **`${HOME}/.local/${APP_NAME}`** (live: `${HOME}/.local/git-sync`).  
2. `util_persistent_storage_dir` **MUST** print that path.  
3. `util_resolve_persistent_storage` **MUST** `mkdir -p` it, confirm it is writable, then print it. Fail closed on create/write failure.  
4. If the resolved path is `${HOME}/.local/bin` (or ends with `/.local/bin`), **MUST** `out_die` — that is the install bin, not persistence.

### 2.5 Isolation

1. Cache preferred/tmp leaves **MUST** include **app identity** (`cache-${APP_NAME}`).  
2. Persistence **MUST** sit under **this login’s** `${HOME}` (home **is** the user isolation).  
3. Fallback cache under XDG **MUST** include app identity (`cache-${APP_NAME}`).  
4. **MUST NOT** rewrite either resolver to a single shared world-writable directory for all users.  
5. Live product **MUST** export `TMPDIR=${EFFECTIVE_STORAGE_DIR}` so `mktemp -t` install staging inherits the isolated **cache** root.

### 2.6 Wire and diagnostics

When this requirement is Active, the live CLI **MUST** wire both classes — a defined-but-unused helper is incomplete:

| Surface | Requirement |
|---------|-------------|
| `app_main` | Resolve once early: `EFFECTIVE_STORAGE_DIR=$(util_resolve_storage)`; `PERSISTENT_STORAGE_DIR=$(util_resolve_persistent_storage)`; export both plus config fallback `STORAGE_DIR`; **`TMPDIR=${EFFECTIVE_STORAGE_DIR}`** |
| `app_about` JSON | Include `cache_preferred`, `cache_fallback`, `persistence_storage`, live chosen cache root `effective_storage`, and config field `storage_dir`; **MUST NOT** include `CHECKSUM` |
| `app_about` human | **Cache folder (preferred):** `/dev/shm/cache/cache-git-sync` · **Cache folder (fallback):** XDG `cache-git-sync` · **Persistence storage:** `${HOME}/.local/git-sync`. **MUST NOT** label those lines Storage (effective) / Storage (fallback) |

### 2.7 Implementation Notes (this project)

| Item | Live value |
|------|------------|
| **Product / binary** | `git-sync` (`./git-sync`) |
| **Cache resolver** | `util_resolve_storage` in `./git-sync` |
| **Persistence resolver** | `util_resolve_persistent_storage` in `./git-sync` |
| **Preferred cache** | `/dev/shm/cache/cache-git-sync` |
| **Fallback cache** | `${XDG_CACHE_HOME}/cache-git-sync` (XDG default `${HOME}/.cache`) |
| **Persistence folder** | `${HOME}/.local/git-sync` |
| **Config fallback `STORAGE_DIR`** | `: "${STORAGE_DIR:=${XDG_CACHE_HOME}/cache-${APP_NAME}}"` |
| **Isolation keys** | App name on cache leaves; `${HOME}` on persistence |
| **Call sites** | `app_main` (cache + persistence + `TMPDIR`); `app_about` (human + JSON) |
| **Not used for** | Domain Git working trees; install binary placement |
| **Output SSOT on failure** | `out_die` |
| **Tests** | `tests/test_cli.sh` — **TP-CLI-05**: `cache_preferred` / `cache_fallback` / `persistence_storage` / `effective_storage`; human Cache folder + Persistence storage; live dirs exist |

### 2.8 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): Multi-user / sudo / containers — never mix users’ scratch or durable files.  
- **CIAO Principle 2 – Intentional Verbosity & Transparency** (https://github.com/cloudgen/ciao): Storage = **cache folder and persistence folder**; about says both.  
- **CIAO Principle 3 – Anti-fragile** (https://github.com/cloudgen/ciao): Missing `/dev/shm` still works via `/tmp` or user cache; persistence stays under `${HOME}`.  
- **CIAO Principle 11 – Safe Temporary File Handling** (https://github.com/cloudgen/ciao): `TMPDIR` inherits the isolated cache root.  
- **CIAO Principle 19 – Defensive Storage Location Handling** (https://github.com/cloudgen/ciao): Create-before-return; fail closed; never assume the folder exists.  
- **CIAO Principle 4 / 20 – Over-protect** (https://github.com/cloudgen/ciao): Forbid “simplify” to shared dumps; forbid dropping persistence from about.  
- **CIAO Principle 21 – Dual Policies** (https://github.com/cloudgen/ciao): Portable two-class rule; filled live paths in Implementation Notes.

---

## Under command line for normal user only

When this program runs on Termux, Git Bash, Windows Command Prompt, or the same class: **admin privilege** and **dedicated system user privilege** are unused. Do not implement in-tool `sudo`, wrap Linux `apt`/`dnf`, create a dedicated system user, or recommend `sudo curl | sh`. Git Bash and Windows Command Prompt must not invoke Termux `pkg`.

**This requirement:** Cache folder and persistence folder stay under this login (`/dev/shm` / `/tmp` / `${HOME}`). Do not switch to `/var` as dest on Termux / Git Bash / Windows Command Prompt.


## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Assume mounts missing; isolate per app and per login.  
- **Intentional:** Cache folder **and** persistence folder; about labels match the two classes.  
- **Anti-fragile:** Volatile first, user cache last for **scratch**; durable data never depends on `/dev/shm`.  
- **Over-protect:** Ban ram-drive-shaped cache paths; ban `${HOME}/.local/bin` as persistence.

---

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Mention only a cache folder and omit the **persistence folder** from this requirement or from `about`.  
2. Remove app identity from cache leaves or move persistence off `${HOME}/.local/${APP_NAME}`.  
3. Replace either fallback chain with a single shared world-writable path.  
4. Scatter new hard-coded `/tmp/${APP_NAME}` cache roots outside the resolver.  
5. Use `/dev/shm/${APP_NAME}` or `/dev/shm/${APP_NAME}-${USERNAME}` as the preferred cache. Preferred **MUST** be `/dev/shm/cache/cache-${APP_NAME}`.  
6. Use `${HOME}/.local/bin` or a Type 1 `/var/…` deposit as the persistence folder.  
7. Leave the resolvers as dead code with no `app_main` / about wire while claiming storage is product law.  
8. Echo a tier path **without** creating it (or without fail-closed create).  
9. Bypass Output SSOT for storage failure messages.  
10. Put `CHECKSUM` in about storage diagnostics.  
11. Label about cache lines **Storage (effective)** / **Storage (fallback)** instead of **Cache folder (preferred)** / **Cache folder (fallback)**.  
12. Store scratch/temps in the persistence folder when a cache root is available.

**Violating this rule is a critical storage isolation regression.**

---

## 5. Definition of done (shell CLI storage)

Storage work for git-sync is **not done** if any of the following fail:

1. Exactly one authoritative **cache** resolver (`util_resolve_storage`) returns the chosen path on stdout after `mkdir -p` of that root.  
2. Exactly one authoritative **persistence** resolver (`util_resolve_persistent_storage`) creates `${HOME}/.local/${APP_NAME}` and prints it.  
3. Cache resolve priority matches this requirement (writable `/dev/shm/cache/cache-${APP_NAME}` → `/tmp/cache/cache-${APP_NAME}` → `STORAGE_DIR` fallback).  
4. Persistence folder is `${HOME}/.local/git-sync` — **not** `${HOME}/.local/bin`.  
5. `app_main` sets `EFFECTIVE_STORAGE_DIR` and `PERSISTENT_STORAGE_DIR`; exports `TMPDIR` from the **cache** resolver once early.  
6. `app_about` human shows **Cache folder (preferred)** / **Cache folder (fallback)** / **Persistence storage**; JSON includes `cache_preferred`, `cache_fallback`, `persistence_storage`, `effective_storage`; **omits** `CHECKSUM`.  
7. User-visible storage failures use Output SSOT (`out_die` / structured error).  
8. Tests cover **TP-CLI-05** (`tests/test_cli.sh`; `reviews/test-plan.md`).  
9. Implementation changes cite this requirement key `requirement-shell-cli-storage` / `RQ-SHELL-CLI-STORAGE`.

---

## 6. Design-time verification

| TP-ID | Intent | Suite | Status |
|-------|--------|-------|--------|
| **TP-CLI-05** | About cache folder + persistence folder | `tests/test_cli.sh` | have (this change) |
| **TP-CLI-04** | About JSON purity (no `CHECKSUM`) | `tests/test_cli.sh` | have |

**Map:** `reviews/test-plan.md` · `reviews/requirement-test-matrix.md`

---

## 7. Related artifacts

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry SSOT |
| `docs/requirements/requirement-shell-modular-function-design.md` | `util_*` ownership |
| `docs/requirements/requirement-shell-output-requirements.md` | about JSON via `out_json`; class B stdout |
| `docs/requirements/requirement-shell-self-management.md` | about lifecycle |
| `docs/requirements/requirement-domain-git-sync.md` | Domain trees are **not** this resolver |
| `./git-sync` | Implementation under test |
| `tests/test_cli.sh` | **TP-CLI-05** |
| `reviews/test-plan.md` | TP map |

---

**Last Updated**: 2026-09-06  
**Owner**: git-sync project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; CIAO Principles 1, 2, 3, 4, 5, 11, 19, 20, 21 (v2.10.2) (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
