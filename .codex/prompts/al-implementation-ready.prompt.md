# BCDA AL Implementation Prompt

Use this prompt only after the readiness gate is Ready.

```text
Use $bcda-al-implementation, $bcda-sdd-steward, $bcda-security-audit, and $bcda-test-validation.

Implement this approved BC Data Agent AL change:
<describe the implementation task>

Before editing:
- Confirm docs/code-generation-readiness.md says Ready.
- Confirm I explicitly asked for implementation.
- Read docs/implementation-contracts.md.
- Read docs/app-design.md and docs/al-development-standards.md.
- Read docs/requirements.md, docs/acceptance-criteria.md, and docs/traceability-matrix.md.
- Read docs/security-review.md and docs/symbol-discovery.md.

Implementation rules:
- Do not create BCDA-specific permission set objects.
- Enforce SUPER-only access.
- Always write mandatory audit metadata.
- Make rollback snapshot logging configurable and visible.
- Respect operation retention categories.
- Keep page logic thin and use service codeunits.
- Pass required analyzers or document approved exceptions.

End with files changed, requirement IDs, tests run, tests not run, and residual risks.
```

