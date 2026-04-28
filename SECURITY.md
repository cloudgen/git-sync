# Security Policy

This document outlines security procedures and general security information for **git-sync**.

---

## Supported Versions

| Version | Supported          | Notes |
|---------|--------------------|-------|
| 1.0.x   | ✅ Active          | Current stable branch |
| < 1.0   | ❌ Not supported   | Please upgrade |

---

## Reporting a Vulnerability

**Please do not report security vulnerabilities via public GitHub issues.**

We take all security reports seriously.

**Preferred reporting method:**

Send an email to: **security@cloudgen.dev**

Please include:
- Description of the issue
- Steps to reproduce
- Potential impact
- Affected version(s)
- Any suggested fix (optional)

We aim to acknowledge reports within **48 hours**.

---

## Security Features

### 1. Checksum Verification (v2)

git-sync includes strong, layered download protection aligned with CIAO principles.

**Current official checksum (v1.0.8)**:

```text
cf9e38c00da50efd3d83a57a16d05829cf39901506334c0249f06c6c0ee7ce28
```

### 2. Recommended Secure Installation

```bash
# Most secure method (pinned checksum)
CHECKSUM="cf9e38c00da50efd3d83a57a16d05829cf39901506334c0249f06c6c0ee7ce28" \
  curl -fsSL https://raw.githubusercontent.com/cloudgen/git-sync/main/git-sync | sh
```

### 3. Built-in Protections

- **Explicit CHECKSUM** environment variable support (strict verification)
- **Automatic `.sha256` sidecar** verification when available
- Fail-fast on mismatch with clear security error
- Atomic installation (temp file → `mv`)
- No silent failures
- Version comparison prevents accidental downgrades
- Protection zones around all self-install / self-update logic

---

## Installation Security Best Practices

1. **Preferred**: Use the pinned checksum method shown above.
2. **Standard**: The one-liner still benefits from built-in verification.
3. **Maximum security** (high-trust environments):
   - Download the script manually
   - Verify checksum
   - Review the code before running

---

## Known Risks & Mitigations

| Risk                              | Mitigation |
|-----------------------------------|----------|
| Supply-chain attack on `curl \| sh` | Checksum verification (v2) + manual review encouraged |
| GitHub raw content tampering      | Automatic + explicit checksum checks |
| Malicious self-update             | Version comparison + checksum |
| PATH / permission issues          | Defensive root vs user logic + safety checks |

---

## Responsible Disclosure

We follow responsible disclosure practices:
- Acknowledge receipt within 48 hours
- Provide regular status updates
- Credit reporters (unless anonymity requested)
- Release fix as soon as possible

---

## Contact

- Security reports: **wongcf22@gmail.com**
- General questions / issues: [GitHub Issues](https://github.com/cloudgen/git-sync/issues)

---

**Thank you** for helping keep git-sync secure and trustworthy.

*Built with strict CIAO principles — Caution, Intentionality, Anti-fragility, and Over-protection.*

