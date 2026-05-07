# Release Notes

## Unreleased

Status: Phase 2 foundation implementation.

### Added

- Business Central AL project manifest.
- Business Central-oriented `.gitignore`.
- SDD documentation package under `docs/`.
- Security review for high-risk hidden and posted data correction behavior.
- Code-generation readiness gate that blocks AL source generation.
- Project-local implementation skills under `.codex/skills/`.
- ADR-003 defining `SUPER`-only access and blocking BCDA-specific permission sets.
- ADR-004 defining configurable rollback snapshot logging and operation retention.
- App design and AL development standards documents.
- Project-local prompt library under `.codex/prompts/`.
- Business Central target updated to version 28.0 with AL runtime 17.0.
- Readiness audit document.
- Phase 2 foundation AL objects under `src/`.
- SUPER runtime access gate using `User Permissions`.IsSuper(UserSecurityId()).
- App-owned setup, policy, request, line, audit, snapshot, rollback operation, and retention log tables.
- Foundation setup, policy, request, line, audit, and retention pages.
- BC Data Agent profile and BCDA Role Center page for convenient access to available foundation tools.
- Foundation service codeunits for setup, access, policy, audit, serialization, orchestration, retention registration, and metadata gating.
- `ruleset.json` with documented `PTE0004` exception for the no-BCDA-permission-set decision.
- Detailed `UserGuide.md` covering foundation behavior, safe setup, policies, correction requests, audit review, retention, troubleshooting, and planned full workflows.
- Configurable approval requirement and separation so the safer default can require a different `SUPER` approver while one-person companies can explicitly disable approval for standard requests or allow self-approval.

### Changed

- Security model now requires the existing Business Central `SUPER` permission set for all functionality.
- BCDA-specific permission set objects are explicitly out of scope and blocked.
- Design now separates mandatory audit metadata from configurable rollback snapshots.
- Operation retention is now user-controlled by category.
- Object planning docs now align to the current `app.json` range 88100-88149.
- `app.json` now references the project logo in `media/BCDataAgent-logo.png`.
- Local launch configuration now starts on the BCDA Role Center page object 88118.
- `app.json` publisher changed from an email address to `AKSA` to satisfy analyzer guidance.
- Code-generation readiness now allows foundation code only and keeps mutation behavior blocked.
- Approval flow changed from hard-coded second-`SUPER` approval to setup-driven separate-approver behavior.

### Current Boundaries

- Foundation AL code exists and compiles.
- No target data correction behavior exists.
- No rollback execution behavior exists.
- No external API exists.
- No BCDA-specific permission sets exist or should be generated.
- Rollback snapshot logging and retention setup/storage exists, but target execution, cleanup, and release behavior remain gated.

### Next Release Goals

- Deploy foundation package to sandbox.
- Verify SUPER/non-SUPER page access behavior.
- Verify target table/field behavior for preview and mutation before opening the next readiness gate.
- Add validation runner and rollback service only after sandbox evidence is recorded.
