# Changelog

All notable changes to **git-sync** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0] - 2026-08-18

### Changed
- **Bootstrap specialize from selfmanaged 1.2.1** (A→B): ship unit rebuilt on Type 0 `out_*` / `inst_*` / `app_*` architecture
- Domain command is explicit **`sync [START_DIR]`** (empty argv is Type O install-ensure, not domain sync)
- Product version jump to **2.0.0** (major: architecture inheritance + CLI contract alignment with selfmanaged)
- Companion digest: `git-sync.sha256`
- Product law under `docs/requirements/` (Type 0 peers from bootstrap + `requirement-domain-git-sync`)
- SECURITY / README honesty: supported version **2.0.x**, automatic SHA-256 companion outcomes, author-email contact from `LICENSE.md`

### Added
- Domain prefix `gs_*` (`gs_main_loop`, `gs_per_repo`) with JSON summary (`type=sync`)
- Env overrides `GS_REMOTE` (default `origin`) and `GS_BRANCH` (default `main`)
- Path free-token → `sync` (e.g. `git-sync ~/projects`)
- Legacy 1.0.7 ship unit archived under `.bootstrap-archive/`
- Bootstrap origin binary kept as workspace reference: `./selfmanaged`

### Preserved
- Direct-child-only `.git` scan (non-recursive)
- `git reset --hard HEAD` then pull; pull failures remain non-fatal per-repo (legacy tolerance)

---

## [1.0.8] - 2026-04-28

### Fixed
- `self-uninstall` now correctly detects and removes user-level installation (`~/.local/bin/git-sync`)
  - Changed default `FORCE_GLOBAL:=1` → `FORCE_GLOBAL:=0` so normal users are no longer forced into global-only path
  - User installs now take priority (local → global fallback) as originally intended

### Changed
- Removed temporary debug line (`info "bin_path=..."`) from `self_uninstall()`

---

## [1.0.7] - 2026-04-28

### Added
- ShellParser Maintainability Layer documentation (top header)
- Clear instructions for `shell-parser split` / `replace` workflow
- Automatic backup handling notes for recovery

### Changed
- Normalized function names (`maybe_install_v4` → `maybe_install`)
- Major refactoring of large functions for better maintainability:
  - `self_uninstall()` → split into 3 focused helpers
  - `add_to_shell_path()` → split into bash/zsh/fish helpers
  - `perform_self_install()` → split into 4 steps (prepare, download with/without checksum, atomic install)
- Enhanced top comment block with ShellParser guidance for future AI/human collaboration

### Fixed
- Removed duplicate `git_sync_main_loop()` definition
- Fixed bare `error` calls (now use `output_text`)
- Cleaned up duplicate comment blocks after ShellParser split

---

## [1.0.6] - 2026-04-28

### Added
- Safety check in `self_uninstall_cleanup_path()`: keeps `~/.local/bin` in PATH if directory is not empty
- Full CIAO-Lite compliant comment blocks for all output functions
- Improved Git-specific function documentation

### Changed
- Split `self_uninstall()` into smaller, focused functions
- Enhanced defensive comments and protection zones

---

## [1.0.5] - 2026-04-28 (Initial Public Release)

### Added
- Core functionality: reset --hard + pull origin main for direct subfolder Git repos
- Full self-install / self-update / self-uninstall with checksum verification (v2)
- JSON output mode, quiet mode, color support
- Portable POSIX shell compatibility (dash, ash, bash, zsh, fish)
- One-liner install support (`curl | sh`)

### Features
- Zero dependencies
- Root and user-level installation support
- Multi-shell PATH management (bash, zsh, fish)

---

## [1.0.0] - 2026-04 (Internal)

- Initial CIAO-based implementation

