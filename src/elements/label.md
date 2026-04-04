# label

## Definition
An element that displays text content — static strings, data-bound
values, or formatted combinations of both. Labels are read-only;
they do not accept input and do not trigger actions directly. They
are the primary mechanism for presenting information to the user:
headings, body text, status messages, data values, and descriptive
copy all use the label type.

## WML Origin
WML `<p>` (paragraph). WML's block-level text element was `<p>`,
which rendered a paragraph of text. MADL uses `label` rather than
`text` or `paragraph` because it is the term used in both iOS
(UILabel) and Android (TextView) native APIs, making it immediately
recognisable to developers and AI agents familiar with either platform.

## ID Pattern
```
Pattern:  {slot}.e{n}   with   type: label
Example:  trk.d3.c1.s1.e1
```

## Declaration Format
```yaml
{element_id}:
  type:       label
  label:      {static string | "{binding_expression}"}
  bound-to:   {endpoint_id | store_path}   # optional — for dynamic values
  text-role:  heading | subheading | body | caption | value | status
              # optional — semantic role hint for styling
  visible-if: {condition}                   # optional
```

## Text role vocabulary

| text-role    | Semantic meaning                                      |
|--------------|-------------------------------------------------------|
| `heading`    | Primary title of the card or section                  |
| `subheading` | Secondary title or section label                      |
| `body`       | Main body copy — explanatory or descriptive text      |
| `caption`    | Small supplementary text — timestamps, metadata       |
| `value`      | A data value being displayed (number, date, string)   |
| `status`     | A state or condition message (saved, error, loading)  |

## Example
```yaml
# Static heading
trk.d2.c1.s1.e1:
  type:      label
  label:     Enter your data
  text-role: heading

# Data-bound value
trk.d3.c1.s1.e1:
  type:      label
  text-role: value
  bound-to:  trk.store.db.ep.history_1

# Status message — conditionally visible
trk.d2.c3.s1.e1:
  type:       label
  label:      Saving...
  text-role:  status
  visible-if: save.in_progress == true

# Caption with timestamp
trk.d3.c1.s2.e2:
  type:      label
  text-role: caption
  bound-to:  trk.store.db.entry.timestamp

# Combination — static prefix with bound value
trk.d3.c1.s1.e2:
  type:      label
  label:     "Entry: {entry.value}"
  text-role: body
```

## Notes
- `label` (the property) and `label` (the element type) share a name.
  In a declaration, `type: label` identifies the element type.
  The `label:` property on that element holds the display string.
  This is not ambiguous in YAML but worth being aware of when reading.
- `bound-to` and a static `label:` string are mutually exclusive as
  the primary content source. Use `bound-to` for dynamic values.
  Use `label:` for static strings. For combined content (static prefix
  + dynamic value), use a template expression in the `label:` string.
- `text-role` is a styling hint only. It does not affect behaviour.
  It tells the implementation what visual weight and size to apply.
  Implementations are free to map roles to their own design system tokens.
- A label with neither `label:` nor `bound-to` is invalid — it has no
  content to display. Every label must have at least one content source.
- Platform mappings: UILabel (iOS), TextView (Android),
  Text (React Native), `<p>` / `<span>` / `<h1>`–`<h6>` (Web).
