# overlay

## Definition
An element rendered above the card surface, on a separate visual layer.
Overlays interrupt or supplement the current card without navigating
away from it. Every overlay must declare a sub-type and a modal value.
The sub-type determines the shape and behaviour of the overlay.
The modal value determines whether the user can interact with the
card behind it while the overlay is visible.

## WML Origin
New. WML had no overlay concept — every interaction resulted in a
card change or a navigation. MADL introduces overlay as a first-class
element because modern mobile UX relies heavily on sheets, dialogs,
toasts, and tooltips that exist on a separate plane from the card
content. Making overlays addressable elements (with their own IDs)
ensures they are specified, not improvised.

## ID Pattern
```
Pattern:  {card}.o{n}
Example:  trk.d2.c1.o1
```

Note: overlay IDs are children of the card, not of a slot. Overlays
are not placed in slots — they float above the entire card surface.

## Declaration Format
```yaml
{card}.o{n}:
  type:         overlay
  overlay-type: dialog | sheet | toast | tooltip | action-sheet   # MUST
  modal:        true | false                                        # MUST
  label:        {string}              # title or message text
  auto-dismiss: {integer}             # seconds — toast only
  visible-if:   {condition}           # optional
```

## Overlay sub-type vocabulary

| overlay-type  | Shape               | modal       | Dismissal                    |
|---------------|---------------------|-------------|------------------------------|
| `dialog`      | Centered card       | always true | Tap button inside dialog     |
| `sheet`       | Bottom panel        | declare explicitly | Swipe down or tap outside |
| `toast`       | Bottom notification | always false | Auto-dismiss after N seconds |
| `tooltip`     | Bubble near element | always false | Tap outside or tap element   |
| `action-sheet`| Bottom list         | always true | Tap option or Cancel         |

## Example
```yaml
# Confirmation dialog
trk.d2.c2.o1:
  type:         overlay
  overlay-type: dialog
  modal:        true
  label:        Discard changes?

# Success toast
trk.d2.c3.o1:
  type:         overlay
  overlay-type: toast
  modal:        false
  label:        Saved successfully
  auto-dismiss: 3

# Action sheet for item options
trk.d1.c1.o1:
  type:         overlay
  overlay-type: action-sheet
  modal:        true
  label:        Item options

# Non-modal sheet for supplementary info
trk.d3.c1.o1:
  type:         overlay
  overlay-type: sheet
  modal:        false
  label:        Entry details

# Tooltip on a field
trk.d2.c2.o1:
  type:         overlay
  overlay-type: tooltip
  modal:        false
  label:        Enter your measurement in the selected unit
```

## Triggering and dismissing overlays

Overlays are shown and hidden via triggers and actions on the parent card:

```yaml
# Show overlay on tap
trk.d1.c1.t5:
  gesture: long-press
  element: trk.d1.c1.s1.e1
  action:
    type:   none           # no navigation — overlay appears in place
    target: trk.d1.c1     # stays on same card

# The overlay's own dismiss control fires modal-dismiss
trk.d2.c2.t6:
  gesture: tap
  element: trk.d2.c2.o1   # referencing the overlay itself as the element
  action:
    type:   modal-dismiss
    target: trk.d2.c2
```

## Notes
- `modal: true` means the card behind the overlay is dimmed and
  non-interactive. `modal: false` means the card behind remains
  interactive while the overlay is visible.
- `dialog` is always `modal: true`. Declaring `modal: false` on a
  dialog is a specification error.
- `toast` is always `modal: false`. It must include `auto-dismiss`
  with a value in seconds. A toast without `auto-dismiss` is invalid.
- `tooltip` is always `modal: false`. It dismisses when the user
  taps elsewhere or taps the element it is attached to.
- `action-sheet` is always `modal: true`. Its items are declared as
  implementation details — MADL specifies that an action sheet exists
  and its title, not its individual options (those are controls or
  implementation concerns).
- A `sheet` with `modal: false` (non-modal bottom sheet) allows the
  user to interact with the card behind it. This is the pattern used
  in mapping applications where a detail panel slides up but the
  map behind remains pannable.
- Platform mappings:
  dialog → UIAlertController / AlertDialog / Alert
  sheet → UISheetPresentationController / BottomSheetDialog / @gorhom/bottom-sheet
  toast → — (iOS has no native toast) / Snackbar / Toast
  tooltip → UIPopoverPresentationController / PopupWindow / Tooltip
  action-sheet → UIAlertController actionSheet / BottomSheetDialog with list
