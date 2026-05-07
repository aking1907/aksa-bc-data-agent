# SDD Index

This is the source-of-truth map for the BC Data Agent project. The project is in documentation-first mode: no AL code should be generated until `docs/code-generation-readiness.md` explicitly allows it and the user asks for implementation.

## Source Order

Higher-order documents define intent. Lower-order documents may refine details, but must not contradict higher-order intent.

| Order | Document | Purpose |
| --- | --- | --- |
| 1 | `docs/sdd-index.md` | SDD rules and source map. |
| 2 | `docs/project.md` | Product intent, scope, workflows, phases. |
| 3 | `docs/requirements.md` | Stable requirement IDs. |
| 4 | `docs/domain-model.md` | Business vocabulary and invariants. |
| 5 | `docs/app-design.md` | User-facing app design and workflow design. |
| 6 | `docs/architecture.md` | Technical design direction. |
| 7 | `docs/al-development-standards.md` | Microsoft-aligned AL implementation standards. |
| 8 | `docs/adr/` | Accepted or proposed architecture decisions. |
| 9 | `docs/open-decisions.md` | Known assumptions and unresolved choices. |
| 10 | `docs/data-model.md` | Planned app-owned data and retention. |
| 11 | `docs/api-contract.md` | Internal and external contract boundary. |
| 12 | `docs/symbol-discovery.md` | Verified Business Central symbol facts. |
| 13 | `docs/acceptance-criteria.md` | Observable done conditions. |
| 14 | `docs/implementation-contracts.md` | Planned object and procedure responsibilities. |
| 15 | `docs/implementation-plan.md` | Build sequence and gates. |
| 16 | `docs/code-generation-readiness.md` | Final gate before code. |
| 17 | `docs/readiness-audit.md` | Current audit of readiness and blockers. |
| 18 | `docs/test-plan.md` | Validation map. |
| 19 | `docs/traceability-matrix.md` | Requirement-to-test coverage. |
| 20 | `docs/risk-register.md` | Active risk management. |
| 21 | `docs/deployment.md` | Environment and release steps. |
| 22 | `docs/operations-runbook.md` | Support and troubleshooting. |
| 23 | `docs/upgrade-release-strategy.md` | Lifecycle governance. |
| 24 | `docs/ai-governance.md` | Rules for AI-assisted work. |
| 25 | `docs/security-review.md` | High-risk security review. |
| 26 | `docs/admin-guide.md` | Planned administrator guide. |
| 27 | `docs/release-notes.md` | Release and documentation history. |
| 28 | `README.md` | Human-facing entry point. |

## Artifact Coverage Matrix

| Area | Covered By | Status |
| --- | --- | --- |
| Product idea | `project.md`, `README.md` | Drafted |
| Requirements | `requirements.md`, `acceptance-criteria.md` | Drafted |
| Domain language | `domain-model.md` | Drafted |
| Architecture | `architecture.md`, `adr/` | Drafted |
| App design | `app-design.md` | Drafted |
| AL standards | `al-development-standards.md` | Drafted |
| Data ownership | `data-model.md` | Drafted |
| Platform evidence | `symbol-discovery.md` | Needs BC symbol verification |
| APIs/contracts | `api-contract.md`, `implementation-contracts.md` | Drafted |
| Implementation sequencing | `implementation-plan.md`, `code-generation-readiness.md` | Code blocked |
| Readiness audit | `readiness-audit.md` | Not ready for code |
| Tests | `test-plan.md`, `traceability-matrix.md` | Drafted |
| Security and compliance | `security-review.md`, `risk-register.md` | Drafted |
| Deployment and support | `deployment.md`, `operations-runbook.md` | Drafted |
| Release lifecycle | `upgrade-release-strategy.md` | Drafted |
| AI governance | `ai-governance.md` | Drafted |
| Release history | `release-notes.md` | Drafted |
| Project skills | `.codex/skills/` | Drafted |
| Project prompts | `.codex/prompts/` | Drafted |
| AI cost governance | `cost/` | Initialized |

## SDD Rules

- Documentation leads implementation.
- No AL source files are generated during this preparation step.
- Every new code object must trace to a requirement, acceptance criterion, and test scenario.
- Posted table and hidden data modifications are treated as break-glass operations.
- Audit entries are append-only; rollback creates new audit entries and never deletes history.
- Rollback must restore business data from captured before-images, not erase the evidence of the correction.
- Sensitive values must be protected in UI, exports, logs, telemetry, and future tests.
- Audit metadata is mandatory; rollback before-image snapshots are configurable and must be visibly enabled, disabled, retained, or expired.
- Retention for app-owned operation data must be user-configurable and should use Business Central native retention policy capabilities when feasible.
- Future implementation agents should use the relevant project skill from `.codex/skills/` before changing architecture, AL code, UX, tests, security, release, or symbol discovery artifacts.
- Future implementation agents should start from the relevant project prompt in `.codex/prompts/` when beginning repeatable workflows.
- Future AI-assisted work should keep compact cost rollups in `cost/` without storing prompts, transcripts, secrets, customer data, posted values, hidden values, or rollback before-images.

## Project Skills

| Skill | Use For |
| --- | --- |
| `bcda-sdd-steward` | SDD alignment, readiness, requirements, acceptance, and traceability. |
| `bcda-architecture-guardian` | Architecture boundaries, ADRs, services, data ownership, and rollback/audit flow. |
| `bcda-al-implementation` | AL implementation after readiness is approved. |
| `bcda-security-audit` | `SUPER` access, posted data risk, redaction, audit, rollback, and exports. |
| `bcda-ux-design` | Business Central page/workflow usability and safe `SUPER` user experience. |
| `bcda-test-validation` | Test planning, acceptance coverage, sandbox proof, and release validation. |
| `bcda-release-ops` | Deployment, operations, upgrade, release notes, and support readiness. |
| `bcda-symbol-discovery` | BC symbol/runtime evidence before platform-dependent code. |

## Project Prompts

| Prompt | Use For |
| --- | --- |
| `session-kickoff.prompt.md` | Start a new session with project status and blockers. |
| `sdd-maintenance.prompt.md` | Update SDD docs for behavior or scope changes. |
| `symbol-discovery.prompt.md` | Verify Business Central platform behavior before code. |
| `readiness-review.prompt.md` | Decide whether implementation can start. |
| `architecture-review.prompt.md` | Review architecture or workflow design. |
| `ux-design-review.prompt.md` | Design Business Central pages/actions/workflows. |
| `security-audit.prompt.md` | Review SUPER access, audit, rollback, retention, and redaction risks. |
| `implementation-planning.prompt.md` | Plan implementation without generating AL. |
| `al-implementation-ready.prompt.md` | Implement AL only after readiness is Ready. |
| `test-validation.prompt.md` | Plan or review tests and release evidence. |
| `release-ops.prompt.md` | Prepare deployment, operations, upgrade, or release notes. |
| `docs-consistency-check.prompt.md` | Find and fix documentation drift. |

## Readiness Gates

| Gate | Required Evidence | Current Status |
| --- | --- | --- |
| Discovery | Product intent, scope, risks, open decisions documented | Complete |
| Platform verification | BC symbols and AL runtime behavior verified locally | Not complete |
| Security review | `SUPER`-only access model, audit model, rollback rules reviewed | Drafted, needs human review |
| Implementation readiness | `code-generation-readiness.md` says Ready | Not ready |
| Build validation | AL package compiles in sandbox | Not started |
| Release validation | Sandbox correction, rollback, audit, and upgrade tests pass | Not started |
