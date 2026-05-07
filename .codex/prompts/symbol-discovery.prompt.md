# BCDA Symbol Discovery Prompt

Use this prompt before implementing anything that depends on Business Central platform behavior.

```text
Use $bcda-symbol-discovery.

Prepare or perform symbol discovery for BC Data Agent.

Read:
- app.json
- .vscode/launch.json
- docs/symbol-discovery.md
- docs/open-decisions.md
- docs/al-development-standards.md
- docs/implementation-contracts.md

Focus on verifying:
- Target BC version and symbol package versions.
- SUPER access detection/enforcement behavior.
- RecordRef/FieldRef read/write behavior.
- Posted/protected table behavior.
- Supported field types for Phase 1.
- Business Central retention policy APIs for BCDA-owned tables.
- CodeCop/UICop and target deployment cop behavior.

Update docs/symbol-discovery.md with evidence, not guesses.
Do not generate AL implementation code.
```

