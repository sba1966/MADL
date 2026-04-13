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

- **scroll property for list elements** (issue #5)
  Added optional `scroll` property to list element schema with closed
  enumeration: `vertical | horizontal | both`.
  Defaults to `vertical`. Specifies the scroll direction for list elements.
  This is a clarification, not a breaking change: no existing valid MADL file
  becomes invalid.
  Affects: Element declaration schema, Property requirement matrix, VALIDATION_CHECKLIST (CHECK_15).
  Decided: 2026-04-10 via issue #5 sba1966/MADL.

- **overlay_id support for sheet-up and sheet-down transition targets** (issue #7)
  Extended action declaration schema `target` property to accept `overlay_id`
  in addition to `card_id` and `deck_id`. This enables sheet-up and sheet-down
  transitions to legally reference overlay elements as targets.
  This is a clarification, not a breaking change: no existing valid MADL file
  becomes invalid.
  Affects: Action declaration schema, VALIDATION_CHECKLIST (CHECK_02, CHECK_16, CHECK_17).
  Decided: 2026-04-10 via issue #7 sba1966/MADL.

- **Standard card name vocabulary extended** (issue #8)
  Added three new standard card names: `adding` (user creating new record),
  `deleting` (delete operation in flight), and `confirming` (user presented
  with destructive action requiring acknowledgement). Updated inference rules
  to include mapping examples for all standard card names.
  This is a clarification, not a breaking change: no existing valid MADL file
  becomes invalid.
  Affects: Standard card name vocabulary, Inference rule for card naming.
  Decided: 2026-04-10 via issue #8 sba1966/MADL.

- **Runtime form state vocabulary documented** (issue #10)
  Added explicit runtime state vocabulary subsection to guard expression format.
  Defined three closed runtime form state identifiers: `form.valid`, `form.dirty`,
  and `form.pristine`. These were previously used in examples but not formally
  documented as a closed enumeration.
  This is a clarification, not a breaking change: no existing valid MADL file
  becomes invalid.
  Affects: Guard expression format (BASKET_3).
  Decided: 2026-04-10 via issue #10 sba1966/MADL.

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
