# BCDA User Guide Maintenance Prompt

Use this prompt whenever user-facing behavior, setup, page actions, release guidance, or SDD behavior changes.

```text
Use $bcda-user-guide-steward.

Update the BC Data Agent user guide for this change:
<describe the behavior, doc, or code change>

Read:
- UserGuide.md
- docs/sdd-index.md
- docs/project.md
- docs/requirements.md
- docs/acceptance-criteria.md
- docs/app-design.md
- docs/admin-guide.md
- docs/operations-runbook.md
- docs/deployment.md
- docs/release-notes.md
- docs/code-generation-readiness.md

If AL behavior changed, also inspect the relevant files under src/.

Keep current readiness boundaries explicit:
- Foundation setup, policy, request, audit, retention-log, and SUPER-gated shell behavior may be documented.
- Target mutation, rollback execution, arbitrary target value preview, audit export, and production enablement remain blocked until the next readiness gate.

Update UserGuide.md and any related admin/operations/release docs needed to prevent drift.

End with UserGuide.md sections updated, related docs updated, readiness status, and remaining user-guide gaps.
```
