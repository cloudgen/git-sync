# =============================================================================
# tests/test_git_sync_domain.sh — TP-GIT-SYNC-* domain surface
# =============================================================================
# Primary REQ: requirement-domain-git-sync.md (RQ-DOMAIN-GIT-SYNC)
# Map: reviews/test-plan.md · RTM: reviews/requirement-test-matrix.md
# =============================================================================

# shellcheck source=helpers.sh
. "${TESTS_ROOT}/helpers.sh"

# Build a temp tree with N direct-child git repos (no remote).
# Sets GS_FIXTURE_ROOT.
gs_make_fixture() {
    _n="${1-1}"
    GS_FIXTURE_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/gs-fix.XXXXXX")
    _i=1
    while [ "$_i" -le "$_n" ]; do
        _r="${GS_FIXTURE_ROOT}/repo${_i}"
        mkdir -p "$_r"
        (
            cd "$_r" || exit 1
            git init -b main >/dev/null 2>&1
            git config user.email "ci@example.com"
            git config user.name "ci"
            printf 'f%s\n' "$_i" > file.txt
            git add file.txt
            git commit -qm "init ${_i}"
        )
        _i=$((_i + 1))
    done
    mkdir -p "${GS_FIXTURE_ROOT}/not-a-repo"
}

gs_rm_fixture() {
    if [ -n "${GS_FIXTURE_ROOT:-}" ] && [ -d "${GS_FIXTURE_ROOT}" ]; then
        rm -rf "${GS_FIXTURE_ROOT}"
        GS_FIXTURE_ROOT=
    fi
}

run_test_git_sync_domain() {
    t_header "Domain git-sync (TP-GIT-SYNC)"

    require_cmd git
    require_cmd sh

    # --- TP-GIT-SYNC-01: help lists domain verb ---
    _out=$(sh "${SCRIPT}" help 2>/dev/null)
    assert_contains "TP-GIT-SYNC-01 help lists sync" "$_out" "sync"
    assert_contains "TP-GIT-SYNC-01 help mentions START_DIR or subfolder" "$_out" "START_DIR"

    # --- TP-GIT-SYNC-02: about mentions domain useful command ---
    _out=$(sh "${SCRIPT}" about 2>/dev/null)
    assert_contains "TP-GIT-SYNC-02 about mentions sync" "$_out" "sync"

    # --- TP-GIT-SYNC-03: missing start dir fail-closed ---
    _err=$(sh "${SCRIPT}" sync /no/such/git-sync-dir-$$ 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-GIT-SYNC-03 missing start dir exit non-zero" 1 "$_ec"
    assert_contains "TP-GIT-SYNC-03 missing start dir message" "$_err" "does not exist"

    _err=$(sh "${SCRIPT}" --json sync /no/such/git-sync-dir-$$ 2>&1 >/dev/null)
    _ec=$?
    assert_eq "TP-GIT-SYNC-03 missing start dir --json exit 1" 1 "$_ec"
    assert_contains "TP-GIT-SYNC-03 JSON code no_start_dir" "$_err" '"code":"no_start_dir"'

    # --- TP-GIT-SYNC-04: empty scan (dir with no .git children) ---
    _empty=$(mktemp -d "${TMPDIR:-/tmp}/gs-empty.XXXXXX")
    mkdir -p "${_empty}/plain"
    # out_warn for empty match may land on stderr; capture both
    _out=$(sh "${SCRIPT}" sync "${_empty}" 2>&1)
    _ec=$?
    assert_eq "TP-GIT-SYNC-04 empty scan exit 0" 0 "$_ec"
    assert_contains "TP-GIT-SYNC-04 empty scan warns no repos" "$_out" "No Git repos"

    _out=$(sh "${SCRIPT}" --json sync "${_empty}" 2>/dev/null)
    _ec=$?
    assert_eq "TP-GIT-SYNC-04 empty scan --json exit 0" 0 "$_ec"
    assert_contains "TP-GIT-SYNC-04 empty JSON type sync" "$_out" '"type":"sync"'
    assert_contains "TP-GIT-SYNC-04 empty JSON found 0" "$_out" '"found":0'
    rm -rf "${_empty}"

    # --- TP-GIT-SYNC-05: sync processes child repos (reset ok; pull may warn) ---
    gs_make_fixture 2
    _out=$(sh "${SCRIPT}" sync "${GS_FIXTURE_ROOT}" 2>/dev/null)
    _ec=$?
    assert_eq "TP-GIT-SYNC-05 sync two repos exit 0" 0 "$_ec"
    assert_contains "TP-GIT-SYNC-05 finished banner" "$_out" "Finished"
    assert_contains "TP-GIT-SYNC-05 found=2" "$_out" "found=2"

    # --- TP-GIT-SYNC-06: JSON summary counts ---
    _out=$(sh "${SCRIPT}" --json sync "${GS_FIXTURE_ROOT}" 2>/dev/null)
    _ec=$?
    assert_eq "TP-GIT-SYNC-06 sync --json exit 0" 0 "$_ec"
    assert_contains "TP-GIT-SYNC-06 type sync" "$_out" '"type":"sync"'
    assert_contains "TP-GIT-SYNC-06 found 2" "$_out" '"found":2'
    assert_contains "TP-GIT-SYNC-06 ok 2" "$_out" '"ok":2'
    assert_contains "TP-GIT-SYNC-06 repos array" "$_out" '"repos":['
    # JSON purity: no human [INFO]/[OK] prefixes mixed into stdout object
    assert_not_contains "TP-GIT-SYNC-06 no [INFO] in json stdout" "$_out" "[INFO]"
    assert_not_contains "TP-GIT-SYNC-06 no [OK] in json stdout" "$_out" "[OK]"

    # --- TP-GIT-SYNC-07: path free-token → sync ---
    _out=$(sh "${SCRIPT}" "${GS_FIXTURE_ROOT}" 2>/dev/null)
    _ec=$?
    assert_eq "TP-GIT-SYNC-07 free-token path exit 0" 0 "$_ec"
    assert_contains "TP-GIT-SYNC-07 free-token finished" "$_out" "Finished"

    # --- TP-GIT-SYNC-08: empty argv is NOT domain sync (Type O) ---
    # Unreachable channel → non-zero install-ensure, not a successful empty domain sync.
    ci_isolated_env
    _errf="${CI_HOME}/empty-argv-domain.txt"
    _out=$(
        HOME="${CI_HOME}" USER_BIN="${CI_USER_BIN}" \
        SCRIPT_URL="http://127.0.0.1:1/git-sync-unreachable" \
        sh "${SCRIPT}" </dev/null 2>"${_errf}"
    )
    _ec=$?
    if [ "$_ec" -ne 0 ]; then
        t_pass "TP-GIT-SYNC-08 empty argv is install-ensure (non-zero without channel)"
    else
        t_fail "TP-GIT-SYNC-08 empty argv expected non-zero install path, got 0"
    fi
    assert_not_contains "TP-GIT-SYNC-08 empty argv not domain Finished" "$_out" "Finished all repos"
    ci_cleanup_env

    # --- TP-GIT-SYNC-09: non-recursive (nested .git not scanned as direct child only) ---
    # Direct child without .git containing nested repo must NOT be processed as a unit;
    # only direct children with .git. Nested-only tree → empty scan success.
    _nest=$(mktemp -d "${TMPDIR:-/tmp}/gs-nest.XXXXXX")
    mkdir -p "${_nest}/parent/deep"
    (
        cd "${_nest}/parent/deep" || exit 1
        git init -b main >/dev/null 2>&1
        git config user.email "ci@example.com"
        git config user.name "ci"
        echo n > f && git add f && git commit -qm nest
    )
    _out=$(sh "${SCRIPT}" --json sync "${_nest}" 2>/dev/null)
    _ec=$?
    assert_eq "TP-GIT-SYNC-09 nested-only scan exit 0" 0 "$_ec"
    assert_contains "TP-GIT-SYNC-09 nested-only found 0" "$_out" '"found":0'
    rm -rf "${_nest}"

    gs_rm_fixture
}
