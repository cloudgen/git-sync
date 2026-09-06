# Product test plan — git-sync

**Product:** git-sync 2.0.1  
**Ship unit:** `./git-sync`  
**Suite:** `tests/run.sh`  
**Updated:** 2026-09-06  

Status: **have** = green in suite · **todo** = planned · **optional** = gated · **n/a** = not applicable

| TP-ID | Intent | Suite | Primary requirement(s) | Status |
|-------|--------|-------|------------------------|--------|
| TP-CLI-01 | `sh -n` syntax + companion digest match | `tests/test_cli.sh` | RQ-SHELL-CLI-INTERFACE · RQ-SHELL-AUTOMATIC-CHECKSUM | have |
| TP-CLI-02 | version human + JSON | `tests/test_cli.sh` | RQ-SHELL-CLI-INTERFACE · RQ-SHELL-OUTPUT-REQUIREMENTS | have |
| TP-CLI-03 | help lists `sync` · GS_REMOTE/GS_BRANCH · no CHECKSUM | `tests/test_cli.sh` | RQ-SHELL-CLI-INTERFACE · RQ-DOMAIN-GIT-SYNC · RQ-SHELL-AUTOMATIC-CHECKSUM | have |
| TP-CLI-04 | help/about JSON purity | `tests/test_cli.sh` | RQ-SHELL-OUTPUT-REQUIREMENTS | have |
| TP-CLI-05 | about cache folder + persistence folder | `tests/test_cli.sh` | RQ-SHELL-CLI-STORAGE | have |
| TP-CLI-06 | unknown command fail-closed | `tests/test_cli.sh` | RQ-SHELL-CLI-INTERFACE | have |
| TP-CLI-07 | quiet suppresses info | `tests/test_cli.sh` | RQ-SHELL-OUTPUT-REQUIREMENTS | have |
| TP-CLI-08 / TP-U-01 | `env -u HOME` version under set -u | `tests/test_cli.sh` | RQ-SHELL-CLI-INTERFACE | have |
| TP-CLI-09 / TP-LC-09 | zero-arg bad channel non-zero | `tests/test_cli.sh` | RQ-SHELL-CLI-ZERO-ARGUMENTS | have |
| TP-CLI-11 | self-uninstall JSON without force → confirm_required | `tests/test_cli.sh` | RQ-SHELL-SELF-MANAGEMENT · RQ-SHELL-INTERACTIVE-VS-NONINTERACTIVE | have |
| TP-CSUM-01 | companion first-field matches ship unit | `tests/test_cli.sh` | RQ-SHELL-AUTOMATIC-CHECKSUM | have |
| TP-CSUM-05 | CHECKSUM absent from help/about | `tests/test_cli.sh` | RQ-SHELL-AUTOMATIC-CHECKSUM | have |
| TP-LC-* | install / re-install / Type O already-installed / version-check / self-update / uninstall / CHECKSUM pin / downgrade | `tests/test_install_lifecycle.sh` | RQ-SHELL-SELF-MANAGEMENT · RQ-SHELL-CLI-ZERO-ARGUMENTS · RQ-SHELL-IDEMPOTENCY · RQ-SHELL-AUTOMATIC-CHECKSUM | have |
| TP-CURL-01…08 | local curl\|sh silent-class + channel | `tests/test_online_curl_install.sh` | RQ-SHELL-CLI-ZERO-ARGUMENTS · RQ-SHELL-SELF-MANAGEMENT | have |
| TP-CURL-09 | optional published channel | `tests/test_online_curl_install.sh` | RQ-SHELL-SELF-MANAGEMENT | optional |
| TP-GIT-SYNC-01 | help lists `sync` / START_DIR | `tests/test_git_sync_domain.sh` | RQ-DOMAIN-GIT-SYNC | have |
| TP-GIT-SYNC-02 | about mentions sync | `tests/test_git_sync_domain.sh` | RQ-DOMAIN-GIT-SYNC | have |
| TP-GIT-SYNC-03 | missing start dir → no_start_dir | `tests/test_git_sync_domain.sh` | RQ-DOMAIN-GIT-SYNC | have |
| TP-GIT-SYNC-04 | empty scan success + warn | `tests/test_git_sync_domain.sh` | RQ-DOMAIN-GIT-SYNC | have |
| TP-GIT-SYNC-05 | sync child repos human | `tests/test_git_sync_domain.sh` | RQ-DOMAIN-GIT-SYNC | have |
| TP-GIT-SYNC-06 | sync JSON summary purity | `tests/test_git_sync_domain.sh` | RQ-DOMAIN-GIT-SYNC · RQ-SHELL-OUTPUT-REQUIREMENTS | have |
| TP-GIT-SYNC-07 | path free-token → sync | `tests/test_git_sync_domain.sh` | RQ-DOMAIN-GIT-SYNC | have |
| TP-GIT-SYNC-08 | empty argv ≠ domain sync | `tests/test_git_sync_domain.sh` | RQ-DOMAIN-GIT-SYNC · RQ-SHELL-CLI-ZERO-ARGUMENTS | have |
| TP-GIT-SYNC-09 | non-recursive scan | `tests/test_git_sync_domain.sh` | RQ-DOMAIN-GIT-SYNC | have |
| TP-ELEV-* | Type 1 elevation | — | — | n/a (Type 0 only) |

**Run:** `sh tests/run.sh`  
**Last green:** 2026-09-06 — PASS=168 FAIL=0 SKIP=1 (TP-CURL-09 optional)
