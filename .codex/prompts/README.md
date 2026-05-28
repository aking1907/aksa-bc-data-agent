# BCDA Project Prompts

These prompts are reusable starting points for future Codex sessions. They are designed to keep BC Data Agent aligned with the SDD package, project-local skills, SUPER-only access model, configurable rollback snapshot logging, and user-controlled retention.

Use the prompt that matches the task:

| Prompt | Use For |
| --- | --- |
| `session-kickoff.prompt.md` | Start a new session with project status and blockers. |
| `sdd-maintenance.prompt.md` | Update SDD docs for behavior or scope changes. |
| `readiness-review.prompt.md` | Decide whether implementation can start. |
| `architecture-review.prompt.md` | Review architecture or workflow design. |
| `ux-design-review.prompt.md` | Design Business Central pages/actions/workflows. |
| `security-audit.prompt.md` | Review SUPER access, audit, rollback, retention, and redaction risks. |
| `implementation-planning.prompt.md` | Plan implementation without generating AL. |
| `al-implementation-ready.prompt.md` | Implement AL only after readiness is Ready. |
| `test-validation.prompt.md` | Plan or review tests and release evidence. |
| `release-ops.prompt.md` | Prepare deployment, operations, upgrade, or release notes. |
| `docs-consistency-check.prompt.md` | Find and fix documentation drift. |
| `user-guide-maintenance.prompt.md` | Keep `UserGuide.md` aligned with behavior, setup, release, and SDD changes. |

Default rule: generate AL code only within the exact scope allowed by `docs/code-generation-readiness.md`.
