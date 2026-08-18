# Revision review — git-sync 2.0.0 (specialize + H2)

**Date:** 2026-08-11  
**Scope:** Bootstrap specialize selfmanaged → git-sync; H2 harness from genesis; tests + fixes  
**Verdict:** **Pass** (with residual notes)

## 1. Architecture / specialize

| Check | Result |
|-------|--------|
| Direction A→B only (selfmanaged → git-sync) | Pass — A SHA unchanged; archive under `.bootstrap-archive/` |
| Type 0 inheritance (`out_*` / `inst_*` / `app_main`) | Pass |
| Domain prefix `gs_*` separate from lifecycle | Pass |
| Identity / channel retarget (APP_NAME, REPO_NAME, SCRIPT_URL) | Pass — git-sync / 2.0.0 |
| Domain law `requirement-domain-git-sync` four pillars | Pass |
| Empty argv Type O (not legacy bare domain sync) | Pass — documented breaking change |
| Reverse-copy pollution | Absent |

## 2. H2 harness

| Check | Result |
|-------|--------|
| GENESIS_SSOT RAM → PROJECT_SSOT hard-disk | Pass |
| Product REQs not overwritten by genesis | Pass (11 REQs kept) |
| Dest map rebind (not genesis 0 REQs) | Pass — AGENTS + docs/README |
| Ship unit / companion / ShellParser.skill protected | Pass |

## 3. Test plan vs suite

| Area | Plan | Suite | Status |
|------|------|-------|--------|
| Type 0 CLI | TP-CLI / TP-CSUM / TP-U | test_cli.sh | have |
| Lifecycle | TP-LC | test_install_lifecycle.sh | have |
| Online curl local | TP-CURL | test_online_curl_install.sh | have (CURL-09 optional skip) |
| Domain | TP-GIT-SYNC-01…09 | test_git_sync_domain.sh | have |
| Type 1 elev | TP-ELEV | — | n/a |

**Green run:** `sh tests/run.sh` → **PASS=153 FAIL=0 SKIP=1**

## 4. Findings fixed during suite bring-up

| Finding | Severity | Fix |
|---------|----------|-----|
| No `tests/` after specialize (A suite does not prove B) | Critical | Ported Type 0 + domain suite for `./git-sync` |
| Companion digest assert risk (glue HASH+filename) | Med | First-field `awk '{print $1}'` |
| Empty-scan warn not seen on stdout | Low | Domain test captures stderr (`out_warn`) |
| Missing product TP map / RTM | High | `reviews/test-plan.md` + RTM |

## 5. Residual / optional

| Item | Priority |
|------|----------|
| TP-CURL-09 public channel smoke | optional |
| Full product `tests/` in CI workflow (if GH Actions added) | low |
| Domain: dedicated remote fixture for successful `git pull` | optional (pull failure is non-fatal by law) |
| Update RECOMMENDATION.md for 2.0.0 architecture | product docs |
| Housekeeping 2026-08-18 re-ran `sh tests/run.sh` | residual closed for suite honesty — still **PASS=153 FAIL=0 SKIP=1** |

## 6. How to re-run

```bash
cd /path/to/git-sync
sh tests/run.sh
```
