# Requirement → test matrix — git-sync

**Updated:** 2026-09-06  
**Map:** `reviews/test-plan.md`  
**Suite:** `tests/run.sh`

| Requirement-ID | Key | TP families | Suite files | Notes |
|----------------|-----|-------------|-------------|-------|
| RQ-CLASS-SOFTWARE-DEV | requirement-class-software-dev | (class residual) | — | Proven indirectly via POSIX sh suite |
| RQ-SHELL-CLI-INTERFACE | requirement-shell-cli-interface | TP-CLI-* | test_cli.sh | syntax, version, help, about, unknown, flags; dual mention `sync` |
| RQ-SHELL-CLI-ZERO-ARGUMENTS | requirement-shell-cli-zero-arguments | TP-CLI-09 · TP-LC · TP-CURL · TP-GIT-SYNC-08 | test_cli · lifecycle · curl · domain | empty-argv install-ensure |
| RQ-SHELL-CLI-STORAGE | requirement-shell-cli-storage | TP-CLI-05 | test_cli.sh | cache folder + persistence folder |
| RQ-SHELL-OUTPUT-REQUIREMENTS | requirement-shell-output-requirements | TP-CLI-02/04/07 · TP-GIT-SYNC-06 | test_cli · domain | JSON + quiet |
| RQ-SHELL-SELF-MANAGEMENT | requirement-shell-self-management | TP-LC · TP-CLI-11 · TP-CURL | lifecycle · cli · curl | install/update/uninstall |
| RQ-SHELL-IDEMPOTENCY | requirement-shell-idempotency | TP-LC re-install | test_install_lifecycle.sh | already installed |
| RQ-SHELL-INTERACTIVE-VS-NONINTERACTIVE | requirement-shell-interactive-vs-noninteractive | TP-CLI-11 · TP-LC uninstall | test_cli · lifecycle | confirm_required; TTY consume |
| RQ-SHELL-AUTOMATIC-CHECKSUM | requirement-shell-automatic-checksum | TP-CSUM · TP-LC pin | test_cli · lifecycle | companion + pin |
| RQ-SHELL-MODULAR-FUNCTION-DESIGN | requirement-shell-modular-function-design | (indirect) | all | gs_* vs inst_*/app_* |
| RQ-SHELL-SCRIPT-CODING | requirement-shell-script-coding | TP-CLI-01 · TP-CLI-08 | test_cli.sh | shebang / set -u; style indirect |
| RQ-DOMAIN-GIT-SYNC | requirement-domain-git-sync | **TP-GIT-SYNC-01…09** | test_git_sync_domain.sh | domain SSOT; help GS_REMOTE/GS_BRANCH |
