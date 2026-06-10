# BCDA AL Implementation Prompt

Use this prompt when the user asks for BCDA AL implementation under the standing SDD authorization.

```text
Use $bcda-al-implementation, $bcda-sdd-steward, $bcda-security-audit, $bcda-test-validation, and $bcda-user-guide-steward when user-facing behavior changes.

Implement this approved BC Data Agent AL change:
<describe the implementation task>

Before editing:
- Confirm docs/code-generation-readiness.md authorizes continuous local implementation for this scope.
- Confirm I explicitly asked for implementation.
- Read docs/implementation-contracts.md.
- Read docs/app-design.md and docs/al-development-standards.md.
- Read docs/requirements.md and docs/acceptance-criteria.md; read docs/traceability-matrix.md only when reference coverage is useful.
- Read docs/security-review.md and docs/readiness-audit.md.
- Read UserGuide.md when setup, pages, actions, validation, release guidance, or user-visible behavior may change.

Implementation rules:
- Do not create BCDA-specific permission set objects.
- Enforce SUPER-only access.
- Always write mandatory audit metadata.
- Make rollback snapshot logging configurable and visible.
- Respect operation retention categories.
- Keep page logic thin and use service codeunits.
- Update or review UserGuide.md for user-facing behavior changes.
- Pass required analyzers or document approved exceptions.

End with files changed, requirement IDs, tests run, tests not run, UserGuide.md updated/reviewed status, and residual risks.
```
