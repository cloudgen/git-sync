# Changelog

All notable changes to **git-sync** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

