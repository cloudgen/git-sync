**file**: docs/requirements/requirement-domain-git-sync.md  
**Requirement-ID**: `RQ-DOMAIN-GIT-SYNC`  
**Status**: Active (Version 1.0.0)  
**Philosophy**: CIAO / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **project Single Source of Truth for domain product law** of the **git-sync** POSIX shell CLI: **subfolder Git repository reset+pull beyond Type 0 self-management**.

**Specialized from:** bootstrap product **selfmanaged** (Type 0 architecture inheritance) + legacy git-sync domain behavior (direct-child `.git` scan, `reset --hard` + `pull`).

It owns the **four domain pillars**:

1. **Specialized CLI subcommands** (verbs, operands, flags, dispatch routing, error codes)  
2. **Specialized features** (scan scope, git operations, remote/branch, machine contracts, non-goals)  
3. **Specialized project help items** (what `help` must list for domain)  
4. **Specialized project about items** (what `about` must expose for domain guidance)

**Mandatory peers (fail closed):**

| Peer | Requirement-ID | Owns |
|------|----------------|------|
| CLI interface | **RQ-SHELL-CLI-INTERFACE** | Dispatch, empty argv Type O, help routing |
| Shell CLI storage | **RQ-SHELL-CLI-STORAGE** | Cache folder + persistence folder, isolation, about storage fields |
| Output | **RQ-SHELL-OUTPUT-REQUIREMENTS** | `out_*` channels |

**Scope:** Domain command surface, scan/reset/pull semantics, human/JSON domain contracts, help/about domain rows.  
**Out of scope (peer requirements own):** Install / self-update / uninstall / empty-argv install-ensure; full `out_*` catalog; modular prefix system shape; companion-digest integrity; shell cache folder + persistence folder (**RQ-SHELL-CLI-STORAGE**); Type 1 host bootstrap.

**Must not confuse with:** Type 0 lifecycle commands (`install`, `version`, `about`, `version-check`, `self-update`, `self-uninstall`, `help`); recursive monorepo tooling; forge/API clients.

**Registry role:** This is the **one Active domain-requirements SSOT** for git-sync. Parallel Active domain-law files are forbidden; supersede this file before activating a replacement.

**Naming law:** Domain SSOT basename is `requirement-domain-git-sync.md` (subject **git-sync**).

---

### 1.1 Human-facing

**In one sentence:** `git-sync sync DIR` resets and pulls every **direct** child of `DIR` that contains `.git`.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | You name a folder of checkouts. Nested clones are skipped. | `git-sync sync ~/projects` |
| The other role | Each child’s remote/branch (`GS_REMOTE` / `GS_BRANCH`, defaults `origin` / `main`). | `GS_BRANCH=main` |
| Not this file | Install of this program; empty argv. | `git-sync` with no args |

| Includes | Excludes |
|----------|----------|
| Direct children with `.git`; `reset --hard` then `pull` | Recursive walk; merge UI; forge API |
| Path free-token `git-sync ~/projects` | Empty argv meaning sync |

| Surface | What you open | What for |
|---------|---------------|----------|
| `./git-sync` | ship unit | `gs_*` |
| `git-sync sync .` | command | domain |
| `git-sync --json sync /no/such` | command | `no_start_dir` |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Sync a folder | Only immediate children with `.git` are processed. Nested `vendor/.git` is not. | `git-sync sync ~/projects` |
| Machine summary | One JSON object: `found` / `ok` / `failed` / `repos`. | `git-sync --json sync .` |


## 2. Core Rules / Requirements (Mandatory)

### 2.1 Specialized CLI subcommands (normative catalog)

Domain verbs **MUST** be stable unless this requirement is explicitly revised. Dispatch **MUST** run through the single CLI entry (`app_main`); handlers **MUST** live under the domain function prefix (`gs_*`), not under `inst_*` / lifecycle-only helpers.

| Command | Privilege | Handler family | Operands / flags | Required behavior | Typical non-zero outcomes |
|---------|-----------|----------------|------------------|-------------------|---------------------------|
| `sync` | Type 0 (invoker) | `gs_main_loop` / `gs_per_repo` | optional `[START_DIR]`; global `--json` / `--quiet` / `--debug` | Scan **direct** children of `START_DIR` (default `.`) for `.git`; for each repo: `git reset --hard HEAD` then `git pull ${GS_REMOTE} ${GS_BRANCH}` | missing start dir → fail; `git` missing → fail; reset failure per repo → count as failed |

**Invocation sample (dual mention, topic-owner):** `git-sync sync .`  
Also valid: `git-sync ~/projects` (path free-token → `sync`).

**Dispatch rules:**

1. Domain command `sync` **MUST** be recognized in the same global flag parse pass as Type 0 lifecycle commands.  
2. Free token after `sync` **MUST** be treated as `START_DIR`.  
3. A bare path-like free token (`.`, `..`, `./*`, absolute path, or existing directory) **MAY** select domain `sync` with that path when no other command is active.  
4. Empty argv **MUST NOT** run domain sync — empty argv is Type O install-ensure (**RQ-SHELL-CLI-ZERO-ARGUMENTS**).  
5. All user-facing domain messages **MUST** go through centralized `out_*` (**RQ-SHELL-OUTPUT-REQUIREMENTS**).  
6. In `--json` / `--quiet` modes, raw `git` stdout/stderr for reset/pull **MUST** be captured (not mixed into machine JSON on stdout).

### 2.2 Specialized features (normative)

#### 2.2.1 Scan scope

| Rule | Meaning |
|------|---------|
| Direct children only | Only `${START_DIR}/*/` entries that contain `.git` are processed |
| Non-recursive | Nested repos under deeper paths are **not** scanned unless law is revised |
| Non-repo children | Directories without `.git` are silently skipped |
| Empty match set | Zero repos found → success with warning (human) or `found=0` JSON — **not** a hard failure |

#### 2.2.2 Git operations (per repo)

| Step | Required behavior | Failure policy |
|------|-------------------|----------------|
| `cd` into repo | Fail that repo if `cd` fails | Failed |
| `git reset --hard HEAD` | Required; hard failure for that repo if reset fails | Failed |
| `git pull ${GS_REMOTE} ${GS_BRANCH}` | Defaults: remote `origin`, branch `main` | Pull failure is **non-fatal** for that repo (warn; still counted ok) — matches legacy tolerance for already-up-to-date / remote issues |

**Environment overrides (domain):**

| Variable | Default | Meaning |
|----------|---------|---------|
| `GS_REMOTE` | `origin` | Remote name for pull |
| `GS_BRANCH` | `main` | Branch name for pull |

#### 2.2.3 Machine / mode contracts

| Mode | Domain contract |
|------|-----------------|
| Human | Progress via `out_plain` / `out_warn` / `out_success` / `out_error` |
| `--json` | Single summary object via `out_json` type `sync` with counts + `repos` array; **no** mixed human success banners on stdout |
| Quiet | Suppress non-error human noise; errors/warns still allowed |

JSON success fields (minimum when repos processed or empty scan):

| Field | Type | Meaning |
|-------|------|---------|
| `start_dir` | string | Resolved/start directory used |
| `remote` | string | Effective `GS_REMOTE` |
| `branch` | string | Effective `GS_BRANCH` |
| `found` | number | Repos with `.git` discovered |
| `ok` | number | Repos that completed without reset/cd failure |
| `failed` | number | Repos that failed hard (reset/cd) |
| `repos` | array | Objects `{path, status}` with `status` = `ok` \| `failed` |

JSON error codes (stable):

| Code | When |
|------|------|
| `no_start_dir` | `START_DIR` missing or not a directory |
| `git_missing` | `git` not on `PATH` |

**Exit status:** non-zero when start dir invalid, git missing, or `failed > 0`. Pull-only warnings with `failed=0` → exit 0.

#### 2.2.4 Non-goals

- Recursive multi-level monorepo discovery  
- Branch detection / multi-remote strategies (beyond env override)  
- Conflict resolution UI  
- Overwriting Type 0 install channel or bootstrap origin product law  

### 2.3 Specialized project help items

`help` **MUST** list:

- Domain section: `sync [START_DIR]` with default `.` and direct-children-only note  
- Type 0 self-management table retained  
- Global flags retained  
- Environment: `REPO_*` / `SCRIPT_URL` (lifecycle); domain **MUST** document `GS_REMOTE` / `GS_BRANCH` (defaults `origin` / `main`)  

### 2.4 Specialized project about items

`about` **MUST**:

- Keep Type 0 install diagnostics  
- Include at least one useful domain command hint: `${APP_NAME} sync [DIR]`  

Domain-specific storage diagnostics are **not** required (domain does not persist app state beyond git working trees).

---

## Under command line for normal user only

When this program runs on Termux, Git Bash, Windows Command Prompt, or the same class: **admin privilege** and **dedicated system user privilege** are unused. Do not implement in-tool `sudo`, wrap Linux `apt`/`dnf`, create a dedicated system user, or recommend `sudo curl | sh`. Git Bash and Windows Command Prompt must not invoke Termux `pkg`.

**This requirement:** `sync` runs as this login against folders you can already write. Do not wrap `git` in `sudo`.


## 3. Architecture inheritance (from bootstrap A)

| Layer | Rule |
|-------|------|
| Output | `out_*` only |
| Install / lifecycle | `inst_*` / Type O empty argv unchanged |
| Dispatch | Single `app_main` |
| Domain prefix | `gs_*` only for domain handlers |
| Bootstrap origin | **selfmanaged** remains A; never reverse-copy B onto A |

---

## 4. Verification hints

| Check | Pass |
|-------|------|
| `sh -n ./git-sync` | Clean |
| `git-sync version` / `--json` | Identity `git-sync` + product version |
| `git-sync help` | Domain + Type 0 sections |
| `git-sync sync <dir-with-child-repos>` | Processes `.git` children |
| `git-sync sync /no/such` | Non-zero + `no_start_dir` in JSON |
| Empty argv | Install-ensure (not domain sync) |

---

**Last Updated**: 2026-09-06  
**Owner**: product git-sync maintainers

## Design-time verification

| TP family / ID | Suite | Status |
|----------------|-------|--------|
| **TP-GIT-SYNC-01** help lists sync | `tests/test_git_sync_domain.sh` | have |
| **TP-GIT-SYNC-02** about domain hint | `tests/test_git_sync_domain.sh` | have |
| **TP-GIT-SYNC-03** no_start_dir | `tests/test_git_sync_domain.sh` | have |
| **TP-GIT-SYNC-04** empty scan | `tests/test_git_sync_domain.sh` | have |
| **TP-GIT-SYNC-05** human multi-repo sync | `tests/test_git_sync_domain.sh` | have |
| **TP-GIT-SYNC-06** JSON sync summary | `tests/test_git_sync_domain.sh` | have |
| **TP-GIT-SYNC-07** path free-token | `tests/test_git_sync_domain.sh` | have |
| **TP-GIT-SYNC-08** empty argv ≠ domain | `tests/test_git_sync_domain.sh` | have |
| **TP-GIT-SYNC-09** non-recursive | `tests/test_git_sync_domain.sh` | have |

**Matrix:** `reviews/requirement-test-matrix.md`  
**Map:** `reviews/test-plan.md`

