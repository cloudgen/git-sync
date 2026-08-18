# Security Policy

This document outlines security procedures and general security information for **git-sync**.

---

## Supported Versions

| Version | Supported | Notes |
|---------|-----------|-------|
| 2.0.x   | Yes       | Current stable (Type 0 specialize from selfmanaged) |
| 1.0.x   | No        | Superseded by 2.0.0 — please upgrade |
| < 1.0   | No        | Please upgrade |

---

## Reporting a Vulnerability

**Please do not report security vulnerabilities via public GitHub issues.**

**Preferred reporting method:** email **cloudgen.wong@gmail.com** (author-email SSOT from `LICENSE.md`).

Please include:

- Description of the issue
- Steps to reproduce
- Potential impact
- Affected version(s)
- Any suggested fix (optional)

We aim to acknowledge reports within **48 hours**.

---

## Integrity (install / self-update)

git-sync is a POSIX shell CLI with online install and self-update. Integrity is **SHA-256**.

### Automatic companion digest (primary)

When `CHECKSUM` is **unset**, install/self-update **automatically** fetches `${SCRIPT_URL}.sha256` next to the script (same origin as the download).

| Companion outcome | Behavior |
|-------------------|----------|
| HTTP 200 and digest **matches** the downloaded bytes | Continue |
| HTTP 200 and digest **mismatches** | Abort (fail closed) |
| Companion **missing** (no sidecar / non-200) | Warn and continue (best-effort automatic mode) |

Current companion digest of `./git-sync` **2.0.0** (Format A, bare hex):

```text
e6b50decf60e31275e7931c91bbd3d76e5eba2908fd6f32a25902a024b52ab49
```

This is **same-origin** automatic verification, not a second independent publisher. It stops accidental truncation and many same-host swaps; it is **not** the highest-assurance pin.

### Strict pin (optional)

Set `CHECKSUM` to the expected SHA-256 hex to require an exact match (fail closed on mismatch or missing compare).

```bash
CHECKSUM="e6b50decf60e31275e7931c91bbd3d76e5eba2908fd6f32a25902a024b52ab49" \
  curl -fsSL https://raw.githubusercontent.com/cloudgen/git-sync/main/git-sync | sh
```

### Other protections

- Atomic install (temp file → `mv`)
- No silent failures on checksum mismatch
- Version comparison resists accidental downgrade
- Protection zones around install / self-update

---

## Known Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| Supply-chain attack on `curl \| sh` | Automatic companion digest + optional `CHECKSUM` pin + manual review |
| GitHub raw content tampering | Same-origin `.sha256` + optional pin |
| Malicious self-update | Version compare + checksum |
| PATH / permission issues | Defensive root vs user install paths |

---

## Responsible Disclosure

- Acknowledge receipt within 48 hours
- Provide status updates
- Credit reporters unless anonymity is requested
- Ship a fix as soon as possible

---

## Contact

- Security reports: **cloudgen.wong@gmail.com**
- General questions / issues: [GitHub Issues](https://github.com/cloudgen/git-sync/issues)

**Thank you** for helping keep git-sync secure.

*Built with CIAO principles — Caution, Intentionality, Anti-fragility, and Over-protection.*
