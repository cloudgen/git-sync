**file**: docs/requirements/requirement-shell-script-coding.md
**Requirement-ID**: `RQ-SHELL-SCRIPT-CODING`
**Status**: Active (Version 1.0.0)
**Philosophy**: CIAO **v2.10.2** / CIAO-Lite (Caution • Intentional • Anti-fragile • Over-engineered / Over-protect)

## 1. Purpose

This requirement is the **project Single Source of Truth** for **POSIX `/bin/sh` coding style** of **git-sync**.

**Specialize-in intention:** without this file, portable learned lessons (prefixes, `set -u`, no `set -e`, TTY measured outside functions, no `$()` of `read` helpers, check-before-sudo) arrive **raw**. Agents **MUST** code from this requirement and the peer files it **points** at — **MUST NOT** treat coding skills or law molds as product law.

**Own-or-point (do not duplicate full peer bodies):**

| Slice | Owner |
|-------|--------|
| User-facing / JSON output | `requirement-shell-output-requirements` |
| Function prefixes / single-file layout | `requirement-shell-modular-function-design` |
| TTY vs automation / prompts | `requirement-shell-interactive-vs-noninteractive` |
| Cache folder + persistence folder / `TMPDIR` | `requirement-shell-cli-storage` |
| Command surface / dispatcher | `requirement-shell-cli-interface` |
| Domain handlers `gs_*` | `requirement-domain-git-sync` |

This file owns: shebang, POSIX subset, `set -u` / no `set -e`, quoting, `command -v`, function header shape, no-retest-tty restated in product language, do-not-capture-read, in-tool sudo **absence** (no wrap table — this ship unit does not invoke `sudo` as a helper).

---

### 1.1 Human-facing

**In one sentence:** The program file people install is one POSIX `/bin/sh` script; helpers have prefixes; messages go through the output helpers; prompts never hang a pipe.

| Box | Meaning | Example |
|-----|---------|---------|
| You / this login | You run `./git-sync` or the installed `git-sync`. | `git-sync help` |
| The other role | Reviewers and later editors must keep the same prefixes and output helpers. | `out_*` / `gs_*` |
| Not this file | Command names, install channel, and Git scan rules live on peer requirements. | `requirement-domain-git-sync` |

| Includes | Excludes |
|----------|----------|
| Shebang `#!/bin/sh`; quote `"${VAR}"`; `command -v` | Bash arrays, `[[ ]]`, `source` |
| Measure TTY once at entry; helpers read `TTY` | Live `[ -t` inside `prompt_*` as policy |
| Call `prompt_ask` in the current shell | `_x=$(prompt_ask …)` |

| Surface | What you open | What for |
|---------|---------------|----------|
| `./git-sync` | ship unit | live coding rules |
| `git-sync help` | command | listed verbs |

| You do… | What it means | What you type |
|---------|---------------|---------------|
| Edit a helper | Keep the prefix (`out_`, `inst_`, `gs_`, …). User-facing text still goes through `out_*`. Do not introduce `set -e`. | edit `./git-sync` then `sh tests/run.sh` |

---

## 2. Core Rules / Requirements (Mandatory)

### 2.1 Shebang and dialect

1. Ship unit **MUST** start with `#!/bin/sh`.  
2. **MUST** stay in a POSIX `/bin/sh` subset that dash and bash-as-sh accept.  
3. **MUST NOT** use Bash arrays, `[[ ]]`, process substitution, here-strings, or `source` (use `.`).  
4. **MUST** quote expansions: `"${VAR}"`.  
5. **MUST** probe commands with `command -v`, not `which`.

### 2.2 Shell options (this product)

| Option | This product |
|--------|----------------|
| `set -u` | **Used** at script top (unset variables are errors). Functions still set `: "${VAR:=default}"` for values they touch. |
| `set -e` | **MUST NOT** — fail with explicit `out_die` / return, not hidden errexit. |
| `set -eu` | **MUST NOT**. |

### 2.3 Function shape

1. Every function **MUST** use a defined prefix owned by `requirement-shell-modular-function-design` (`out_`, `inst_`, `util_`, `app_`, `ver_`, `path_`, `prompt_`, `gs_`).  
2. Bare function names (`main`, `help`, `install`) are forbidden. User-facing **commands** may stay short words.  
3. Public helpers **MUST** carry a defensive header (purpose, CIAO lines, Protection warning when the body is a protection zone).  
4. Function bodies **MUST** set safe defaults for the variables they use (`: "${VAR:=default}"`).  
5. Product-source `ALIGNMENT` / `See` lines **MUST** cite only live `docs/requirements/requirement-*.md` files registered in `docs/requirements/index.md`.

### 2.4 Output and input SSOT

1. User-facing and machine JSON **MUST** go through `out_*` (`requirement-shell-output-requirements`).  
2. Flags and mode bits **MUST** be parsed once in `app_main`; helpers consume `JSON` / `QUIET` / `TTY` / `DEBUG` / `FORCE`.  
3. Scratch files **MUST** use `mktemp` under the cache folder `TMPDIR` (`requirement-shell-cli-storage`). **MUST NOT** use predictable `$$` temp names.

### 2.5 TTY measurement (no retest)

1. Interactive capability **MUST** be measured in the **main process, outside functions**: `[ -t 0 ]` and `[ -t 1 ]` assign `TTY` (optional `/dev/tty` open check).  
2. `prompt_*`, `out_*` color, and `about` **MUST read `TTY`**.  
3. **MUST NOT** use live `[ -t 0 ]` / `[ -t 1 ]` inside `prompt_*` as the policy gate.  
4. **MUST NOT** capture `prompt_ask` / `prompt_yes_no` / any `read` helper with `$()` or backticks. Assign `PROMPT_ASK_VALUE` in the current shell.

### 2.6 In-tool sudo (this product)

This ship unit **does not** wrap `sudo` for domain or helper work. Global vs user install is **invoker privilege** (already root → `GLOBAL_BIN`; otherwise `USER_BIN`). **MUST NOT** add `util_sudo` or `sudo curl | sh` as a recommended domain path. If a future change invokes `sudo`, specialize a dedicated sudo-command requirement in the same change (studied allow table) — do not keep wrap bodies only here.

### 2.7 Implementation Notes (this project)

| Item | Live value |
|------|------------|
| **Product / binary** | `git-sync` (`./git-sync`) |
| **Shebang** | `#!/bin/sh` |
| **`set -u`** | yes (script top) |
| **`set -e`** | no |
| **Domain prefix** | `gs_*` (`gs_main_loop`, `gs_per_repo`) |
| **TTY** | Set in `app_main` / entry; helpers consume `TTY` |
| **In-tool sudo** | none |
| **Tests** | `tests/run.sh` (`sh -n`, suite) — style proven indirectly; no separate TP-STYLE family |

### 2.8 Why This Requirement Exists (Direct CIAO Alignment)

- **CIAO Principle 1 – Caution** (https://github.com/cloudgen/ciao): POSIX subset; explicit errors; no hidden `set -e`.  
- **CIAO Principle 2 – Intentional** (https://github.com/cloudgen/ciao): Prefixes and output SSOT are named.  
- **CIAO Principle 3 – Anti-fragile** (https://github.com/cloudgen/ciao): `curl \| sh`, dash, Git Bash.  
- **CIAO Principle 4 / 20 – Over-protect** (https://github.com/cloudgen/ciao): Without this file, agents paste raw workshop lessons.  
- **CIAO Principle 21 – Dual Policies** (https://github.com/cloudgen/ciao): Portable rules; filled live notes.

---

## Under command line for normal user only

When this program runs on Termux, Git Bash, Windows Command Prompt, or the same class: **admin privilege** and **dedicated system user privilege** are unused. Do not implement in-tool `sudo`, wrap Linux `apt`/`dnf`, create a dedicated system user, or recommend `sudo curl | sh`. Git Bash and Windows Command Prompt must not invoke Termux `pkg`.

**This requirement:** coding helpers stay **normal user privilege**. Do not add a Type 1 sudo ladder or `util_sudo` “because the workshop sample had one.”

---

## 3. Design Principles (CIAO / CIAO-Lite)

- **Caution:** Assume a minimal `/bin/sh`.  
- **Intentional:** One shebang, one option policy, one prefix table (peer).  
- **Anti-fragile:** Works piped from the network.  
- **Over-protect:** Do not strip headers or reintroduce Bash-only syntax.

---

## 4. Protection Rule (Sacred)

**Future AI assistants, Grok, or maintainers MUST NOT**:

1. Change the shebang away from `#!/bin/sh`.  
2. Add `set -e` or `set -eu`.  
3. Bypass `out_*` for user-facing messages.  
4. Introduce Bash-only syntax as the default dialect.  
5. Measure `[ -t` inside `prompt_*` as policy, or capture `read` helpers with `$()`.  
6. Treat coding skills or molds as product law while this file exists.  
7. Duplicate full `out_*` / prefix / storage tables here instead of pointing.  
8. Add in-tool `sudo` without a dedicated sudo-command requirement and a studied allow table.  
9. Strip **Under command line for normal user only**.

**Violating this rule is a critical coding-style regression.**

---

## 5. Definition of done (shell script coding)

Coding-style work for git-sync is **not done** if any of the following fail:

1. `./git-sync` remains `#!/bin/sh` with `set -u` and without `set -e`.  
2. New functions use a registered prefix.  
3. User-facing output still goes through `out_*`.  
4. TTY is measured outside functions; prompts consume `TTY` and are not captured with `$()`.  
5. Implementation changes cite `requirement-shell-script-coding` / `RQ-SHELL-SCRIPT-CODING`.

---

## 6. Design-time verification

| TP-ID | Intent | Suite | Status |
|-------|--------|-------|--------|
| **TP-CLI-01** | `sh -n` syntax | `tests/test_cli.sh` | have |
| **TP-CLI-08 / TP-U-01** | `env -u HOME` under `set -u` | `tests/test_cli.sh` | have |

Style rules are proven indirectly by the POSIX suite. No separate TP-STYLE family.

**Map:** `reviews/test-plan.md` · `reviews/requirement-test-matrix.md`

---

## 7. Related artifacts

| Artifact | Role |
|----------|------|
| `docs/requirements/index.md` | Registry SSOT |
| `docs/requirements/requirement-shell-modular-function-design.md` | Prefix ownership |
| `docs/requirements/requirement-shell-output-requirements.md` | `out_*` |
| `docs/requirements/requirement-shell-interactive-vs-noninteractive.md` | TTY / prompts |
| `docs/requirements/requirement-shell-cli-storage.md` | cache / persistence / `TMPDIR` |
| `docs/requirements/requirement-shell-cli-interface.md` | dispatcher |
| `docs/requirements/requirement-domain-git-sync.md` | `gs_*` |
| `./git-sync` | Implementation under test |
| `tests/test_cli.sh` | **TP-CLI-01** · **TP-CLI-08** |

---

**Last Updated**: 2026-09-06  
**Owner**: git-sync project maintainers  
**Alignment**: Registry `docs/requirements/index.md`; CIAO Principles 1, 2, 3, 4, 20, 21 (v2.10.2) (https://github.com/cloudgen/ciao); CIAO-Lite (https://github.com/cloudgen/ciao-lite).
