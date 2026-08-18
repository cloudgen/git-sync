# tests — git-sync

CI suite for Type 0 self-management **and** domain `sync` (specialized from selfmanaged).

## Run

```bash
sh tests/run.sh
```

Requires: `sh`, `curl`, `python3` (local HTTP channel), `sha256sum`, `grep`, `git` (domain).

Optional: `RUN_ONLINE_CURL_TESTS=1` for TP-CURL-09 public channel smoke.

## Layout

| File | Role |
|------|------|
| `run.sh` | Entrypoint (CLI → lifecycle → curl → domain) |
| `helpers.sh` | Asserts, isolated HOME, local channel |
| `test_cli.sh` | Type 0 surface + companion (TP-CLI / TP-CSUM / TP-U) |
| `test_install_lifecycle.sh` | Install / update / uninstall / pin (TP-LC) |
| `test_online_curl_install.sh` | curl\|sh silent class local (TP-CURL) |
| `test_git_sync_domain.sh` | Domain sync (TP-GIT-SYNC-*) |

## Maps

- Product TP map: `reviews/test-plan.md`
- RTM: `reviews/requirement-test-matrix.md`

**Version note:** suites read `VERSION` from `./git-sync`. After a bump, refresh `git-sync.sha256` and re-run.
