# slot

## Definition
A named region within a card (or layer) that accepts and contains elements.
Slots divide a card's layout into addressable areas. Every element must belong
to exactly one slot. Slots have no visual representation of their own — they
are organisational containers for elements, not styled regions. The layout
relationship between slots (which is on top, which is on the left) is
determined by the implementation, not by MADL.

## WML Origin
New. WML had no sub-card layout regions — elements were placed directly inside
`<card>`. The `slot` is introduced because modern mobile layouts require a way
to address specific regions of a card without describing pixels or coordinates.
MADL uses slots to say "the element is in the footer area" without specifying
exactly where the footer is on screen.

## ID Pattern
```
Pattern:  {card}.s{n}
          {layer}.s{n}
Example:  trk.d2.c1.s2
          trk.l1.s1
```

## Declaration Format
```yaml
{slot_id}:
  name:     {description}          # optional but recommended
  elements:
    {element_id}: ...
```

## Example
```yaml
trk.d2.c1.s1:
  name: header
  elements:
    trk.d2.c1.s1.e1:
      type:  label
      label: Enter your data

trk.d2.c1.s2:
  name: body
  elements:
    trk.d2.c1.s2.e1:
      type:        field
      placeholder: Data value
    trk.d2.c1.s2.e2:
      type:  field
      placeholder: Notes

trk.d2.c1.s3:
  name: footer
  elements:
    trk.d2.c1.s3.e1:
      type:  control
      label: Save
    trk.d2.c1.s3.e2:
      type:  control
      label: Cancel
```

## Recommended Slot Names

These names are conventional and should be used consistently when the layout
follows standard mobile patterns. Custom names are permitted.

| Name       | Typical position and role                      |
|------------|------------------------------------------------|
| `header`   | Top of card. Title, back button, primary label.|
| `body`     | Main scrollable content area.                  |
| `footer`   | Bottom of card. Primary and secondary actions. |
| `sidebar`  | Side panel (iPad / large screen).              |
| `overlay`  | Reserved for overlay elements (use `o{n}` ID). |

## Notes
- A card MUST have at least one slot if it contains any elements.
- A slot MUST contain at least one element to be declared.
  Empty slots should not appear in the specification.
- Slots within a card have their own `{n}` sequence starting at 1.
  `trk.d2.c1.s1` and `trk.d2.c2.s1` are slots in different cards —
  the `s1` in each refers to the first slot of its respective card.
- Slots do not describe position, size, or visual styling.
  They describe containment only. The implementation decides layout.
- When communicating with an AI coding agent, reference the slot ID
  to specify where a new element should be placed:
  "Add a loading indicator to `trk.d2.c3.s1`" is unambiguous.
  "Add a loading indicator to the top of the saving screen" is not.
- Layers use the same slot pattern: `{app}.l{n}.s{n}`.
