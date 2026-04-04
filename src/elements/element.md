# element

## Definition
The base unit of UI content placed within a slot. Every visible or
interactive item on a card is an element. Elements are always contained
by a slot — they cannot exist outside one. The `element` term is the
abstract parent of all specific element types (field, label, control,
media, list, overlay). In practice, every element declaration must
specify a concrete type. The term `element` is used when referring
to the concept in general, or when addressing any element by its ID
regardless of type.

## WML Origin
WML generic content model. WML cards contained inline elements
(`<input>`, `<select>`, `<p>`, `<img>`, `<anchor>`) without a
unifying parent concept. MADL introduces `element` as the explicit
unifying term so that any item on a card can be referenced by a
stable ID regardless of its specific type, and so that the property
vocabulary (bound-to, visible-if, etc.) has a single declaration point.

## ID Pattern
```
Pattern:  {slot}.e{n}
Example:  trk.d2.c1.s2.e1
```

### Rules for {n}
- Positive integer, assigned sequentially within the parent slot
- Stable and never reused
- Each slot has its own `{n}` sequence
- `trk.d2.c1.s1.e1` and `trk.d2.c1.s2.e1` are different elements
  in different slots of the same card

## Element type enumeration (closed — exhaustive)

Every element declaration MUST include a `type` from this set:

| Type      | Description                                      |
|-----------|--------------------------------------------------|
| `field`   | Accepts user input                               |
| `label`   | Displays static or data-bound text               |
| `control` | Triggers an action (button, toggle, selector)    |
| `media`   | Displays image, video, or audio                  |
| `list`    | Renders a repeating collection of bound items    |
| `overlay` | Rendered above the card surface. Always sub-typed|

## Declaration Format
```yaml
{element_id}:
  type:        {element_type}           # MUST — no default
  label:       {string}                 # display text — optional
  bound-to:    {endpoint_id | store_path} # data source — optional
  visible-if:  {boolean_condition}      # conditional render — optional
```

## Property requirement matrix

| Property      | field | label | control | media | list  | overlay |
|---------------|-------|-------|---------|-------|-------|---------|
| `type`        | MUST  | MUST  | MUST    | MUST  | MUST  | MUST    |
| `label`       | OPT   | OPT   | OPT     | —     | —     | —       |
| `bound-to`    | OPT   | OPT   | —       | OPT   | MUST  | —       |
| `visible-if`  | OPT   | OPT   | OPT     | OPT   | OPT   | OPT     |
| `modal`       | —     | —     | —       | —     | —     | MUST    |

## Example
```yaml
# Referencing elements by ID in a change request:
# "Make trk.d2.c1.s2.e1 visible only when form.mode == 'advanced'"

trk.d2.c1.s2.e1:
  type:       field
  placeholder: Data value
  visible-if: form.mode == 'advanced'

# An element with data binding
trk.d3.c1.s1.e1:
  type:     label
  bound-to: trk.store.db.ep.history_1

# An element on a layer
trk.l1.s1.e1:
  type:  control
  label: Back
```

## Notes
- Elements are addressed by their full cascading ID. When communicating
  with a collaborator or AI agent, always use the full ID:
  `trk.d2.c1.s2.e1` — never "the first field on the data entry screen".
- Triggers are declared on cards, not on elements. An element does not
  own its trigger. The element is referenced by a trigger via the
  `element:` property on the trigger node.
- The `visible-if` property controls whether the element renders at all.
  It is not the same as enabling or disabling an element — a disabled
  element is still visible. If the condition for disabling needs to be
  specified, use a custom property in the implementation notes.
- Elements within a slot are ordered. The order in the YAML declaration
  is the display order. Implementation may adjust this for layout
  reasons, but the spec order is the reference.
- Layer elements follow the same ID pattern but their parent is a layer
  slot: `{app}.l{n}.s{n}.e{n}`.
