# Changelog
All notable changes to MADL will be documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased — 0.2.0]

### Breaking Changes
- **ID format: readable slugs replace numeric shorthand** (issue #3)
  The v0.1 ID pattern `{prefix}{n}` (e.g. `trk.d2.c3.s1.e1`) is replaced
  by readable dot-separated slugs (e.g. `tracker.item-selection.editing.form.save-button`).
  Every segment is a meaningful name, unique among siblings. No length limit.
  No numeric shorthand. No mandatory alias or name fields as compensation.
  Any MADL spec written under v0.1 ID rules produces invalid IDs under v0.2.
  Rationale: an ID that requires a catalog to read has failed the core promise
  of the language — unambiguous description readable by humans and AI without
  external reference. Machine parseability is a tooling concern, not a spec
  concern. Type is declared explicitly in the YAML; the ID does not encode it.
  Affects: RULE_03, ID_HIERARCHY_COMPLETE_REFERENCE, all ID pattern tables,
  EXAMPLE_END_TO_END in agent instructions; reference booklet; cheatsheet.
  Decided: 2026-04-07 via issue #3 sba1966/MADL.

### Added
- **input-type property for field elements** (issue #4)
  Added optional `input-type` property to field declaration schema with closed
  enumeration: `text | number | decimal | email | phone | date | url`.
  Defaults to `text`. Specifies the keyboard type presented to the user when
  the field is focused. This is a clarification, not a breaking change: no
  existing valid MADL file becomes invalid.
  Affects: Element declaration schema, Property requirement matrix, VALIDATION_CHECKLIST (CHECK_14).
  Decided: 2026-04-10 via issue #4 sba1966/MADL.

### Pending
- v0.2 versions of all primary spec documents to be authored
- GitHub milestone v0.2 to be opened to track breaking changes

---

## [0.1.0] — 2026-04-04

### Added
- Initial specification of 34 terms across 5 baskets
- Mandatory cascading ID convention
- 4 closed enumerations: gesture types, transition types, overlay subtypes, host capabilities
- 5 contested term resolutions
- Reference booklet (PDF, A4)
- Cheatsheet (PDF, A4 landscape)
- Agent instruction file for AI coding agents
- Repository scaffold

### WML terms reused
- `deck` · `card` · `entry` · `exit` · `action` (from `<do>`) · `field` (from `<input>`) · `label` (from `<p>`)
