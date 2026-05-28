# Hardening And Release Readiness Kickoff

## Purpose

Record the Phase 9 hardening request, local hardening evidence, and the release-readiness work required before BC Data Agent can be treated as production-ready.

Phase 9 does not bypass earlier readiness gates. It hardens whatever scope is already implemented and proves whether the project is locally releasable. Phase 9 local hardening is complete for the current Phase 8 build, but sandbox release validation is still required before production use.

## Current Completion Decision

Hardening readiness work is complete locally for the currently allowed Phase 8 build.

AL code generation remains limited by `docs/code-generation-readiness.md`. Phase 9 does not open external APIs, non-update rollback, conflict override, unfiltered export, unredacted export, snapshot payload export, or production enablement.

## Hardening Scope Available Now

| Area | Allowed Now | Completion Evidence |
| --- | --- | --- |
| Local build | Compile current AL package and run required analyzers | Complete |
| Configuration | Validate `app.json`, object ranges, launch/ruleset alignment, and no BCDA permission set objects | Complete |
| Documentation consistency | Keep readiness, test, release, admin, operations, and user guide status aligned | Complete locally |
| Security posture | Preserve `SUPER` gate, app-owned table blocks, sanitized errors, and governed target writes | Complete locally; sandbox evidence pending |
| Sandbox readiness | Define sandbox validation required before production use | Complete locally |
| Release operations | Keep deployment, operations, upgrade, and support guidance aligned to current capability | Complete locally |

## Project Completion Blockers

The project cannot be marked fully implemented until all of these are complete:

- Phase 6 execution passes sandbox validation.
- Phase 7 supported update rollback passes sandbox validation.
- Phase 8 audit export and retention cleanup pass sandbox validation.
- Sandbox-backed readiness gates open production policy.
- Sandbox release validation passes for `SUPER`/non-`SUPER`, preview, execution, rollback, audit, export, retention, upgrade, and operations.
- `docs/code-generation-readiness.md` is updated ahead of each implementation pass.

## Phase 9 Exit Criteria

For the current Phase 8 build, Phase 9 local hardening is complete:

- Local AL compile passes.
- Required analyzers pass.
- `app.json` parses and targets the documented BC/runtime version.
- No BCDA-specific permission set AL objects exist.
- No source or docs claim blocked mutation/export/cleanup behavior is available.
- Readiness docs clearly list remaining blockers and next evidence.
- Release notes, deployment, operations, and user guide describe the current safe boundary.

For production release, Phases 6, 7, and 8 still must pass their sandbox validation gates.

## Local Completion Evidence

| Date | Scope | Command Or Review | Result | Evidence | Remaining Risk |
| --- | --- | --- | --- | --- | --- |
| 2026-05-28 | Phase 9 local build | AL compiler package build | Pass | AL compiler 17.0.34.45391 compiled 51 files against BC 28 symbols. | Sandbox deployment validation pending |
| 2026-05-28 | Phase 9 analyzers | CodeCop, UICop, PerTenantExtensionCop with `ruleset.json` | Pass | Analyzer compile completed with no blocking diagnostics. | Sandbox release validation pending |
| 2026-05-28 | Phase 9 configuration | `app.json`, object range, launch/settings/ruleset review | Pass | Target BC 28/runtime 17; object IDs 88100..88149; launch starts Role Center 88118. | None local |
| 2026-05-28 | Phase 9 access model | Source scan for permission set, permission set extension, and entitlement objects | Pass | No BCDA permission-set AL objects found. | Runtime `SUPER` behavior still needs sandbox validation |
| 2026-05-28 | Phase 9 documentation consistency | Status and blocked-scope scan across docs/source | Pass | Phase 9 local completion and remaining sandbox blockers recorded. | Production use remains blocked until sandbox evidence |

## Validation Evidence Template

Record each hardening pass using this shape:

| Date | Scope | Command Or Review | Result | Evidence | Remaining Risk |
| --- | --- | --- | --- | --- | --- |
| 2026-05-28 | Phase 9 local hardening | Compile, analyzers, config, source, and docs review | Pass | Local completion evidence above | Sandbox validation pending |

Do not record customer data, posted values, hidden values, credentials, exported files with sensitive values, or rollback before-images.
