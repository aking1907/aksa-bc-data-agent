# Release Notes

## Unreleased

Status: documentation baseline.

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

### Changed

- Security model now requires the existing Business Central `SUPER` permission set for all functionality.
- BCDA-specific permission set objects are explicitly out of scope and blocked.
- Design now separates mandatory audit metadata from configurable rollback snapshots.
- Operation retention is now user-controlled by category.
- Object planning docs now align to the current `app.json` range 88100-88149.
- `app.json` now references the project logo in `media/BCDataAgent-logo.png`.
- Local launch configuration now uses planned startup page object 88110.

### Current Boundaries

- No AL code exists.
- No data correction behavior exists.
- No rollback behavior exists.
- No external API exists.
- No BCDA-specific permission sets exist or should be generated.
- Rollback snapshot logging and retention behavior are documented but not implemented.

### Next Release Goals

- Complete symbol discovery.
- Resolve blocking open decisions.
- Begin implementation only after readiness is marked Ready and the user approves code generation.
