# app

## Definition

The root container of a MADL-described application. There is exactly one `app`
per product. Every other node in the specification derives its ID from the app
identifier. The `app` node is the single point of truth for the application's
identity and its top-level registry of navigators, layers, and services.

## WML Origin

New. WML had no explicit root container concept — a WML file was implicitly
scoped to a single deck set. MADL makes the root explicit because modern
applications span multiple navigators, layers, and service registries that all
require a common ancestor for ID derivation.

## ID Pattern

```
Pattern:  {app_id}
Example:  tracker
```

### Rules for {app_id}

- Lowercase readable slug, no length limit
- Unique per product — no two products in the same workspace share an ID
- Chosen once at project start and never changed
- Should be the full or natural short form of the product name — readable
  without a catalog

| Product name     | app_id          |
|------------------|-----------------|
| Tracker          | tracker         |
| Finance Manager  | finance-manager |
| Daily Log        | daily-log       |
| Health Monitor   | health-monitor  |

> **Version note:** v0.1 specified a 2–6 character alphanumeric slug
> (e.g. `trk`, `fnmg`). This was superseded in v0.2 by the readable slug
> decision (issue #3). The short abbreviation format is deprecated.

## Declaration Format

```yaml
{app_id}:
  name:     {human readable product name}
  version:  {semver string}
  platform: ios | android | cross
```

## Example

```yaml
tracker:
  name:     Tracker
  version:  0.2.0
  platform: cross
```

## Notes

- The `app` node itself has no visual representation. It is a namespace root.
- All navigators, layers, decks, and services MUST be declared as children
  of the app — either directly or by reference through the atlas.
- When referencing the app in conversation with a collaborator or AI agent,
  use only the `{app_id}`. Never use the human-readable name as an identifier.
  "Change something in tracker" is unambiguous. "Change something in Tracker" is not.
