# card

## Definition
One named configuration of a deck. A card represents a specific condition
in which a deck can exist — what the user sees and what interactions are
available when the deck is in that condition. Multiple cards share the same
deck (same route, same destination) but present different appearances and
behaviours. The user navigates between decks; the application moves between
cards within a deck in response to data and actions.

## WML Origin
WML `<card>`. In WML, each `<card>` element inside a deck file represented
one visible "page" of content. MADL preserves this exactly: a card is the
atomic visible unit within a deck. The key clarification MADL adds is that
cards within a deck share a route — they are conditions of the same
destination, not separate destinations.

## ID Pattern
```
Pattern:  {deck}.c{n}
Example:  trk.d2.c3
```

### Rules for {n}
- Positive integer, assigned sequentially at card creation within its parent deck
- Stable and never reused
- Each deck has its own `{n}` sequence — `trk.d1.c1` and `trk.d2.c1` are
  different cards; the `c1` in each refers to the first card of its respective deck

## Declaration Format
```yaml
{card_id}:
  name:   {standard_card_name | custom_name}
  slots:
    {slot_id}: ...
  triggers:
    {trigger_id}: ...
  overlays:
    {overlay_id}: ...
```

## Standard Card Names

Use these names consistently. They are the closed vocabulary for card conditions.
Custom names are permitted but must be documented in the deck's declaration.

| Name      | Condition                                   |
|-----------|---------------------------------------------|
| `default` | Normal loaded state. Use when no other applies. |
| `empty`   | No data to display. First-use or post-clear.|
| `loading` | Async operation in progress.                |
| `loaded`  | Data present and rendered.                  |
| `error`   | A failure occurred.                         |
| `editing` | User is actively modifying data.            |
| `saving`  | Write operation in flight.                  |
| `success` | Operation completed successfully.           |

## Example
```yaml
trk.d2.c1:
  name: default
  slots:
    trk.d2.c1.s1:
      elements:
        trk.d2.c1.s1.e1:
          type: label
          label: Enter your data below
    trk.d2.c1.s2:
      elements:
        trk.d2.c1.s2.e1:
          type: field
          placeholder: Data value
        trk.d2.c1.s2.e2:
          type: control
          label: Save
  triggers:
    trk.d2.c1.t1:
      gesture: tap
      element: trk.d2.c1.s2.e2
      action:
        type: replace
        target: trk.d2.c3
        guard: form.valid == true
```

## Notes
- The distinction between `card` and `state` is deliberate and enforced.
  `card` is a structural node in the spec — it has an ID, it has slots,
  it has triggers. `state` refers to runtime data values (e.g. the value
  of a field, the result of an API call). Do not use these terms
  interchangeably.
- A card is not a screen. A screen is a colloquial term. A card is
  a precisely addressed node with a mandatory ID.
- Transitions between cards within the same deck do not constitute
  navigation. Navigation is movement between decks. Card changes are
  condition changes — the route does not change, the appearance does.
- Every card transition triggered by an action must be declared in that
  card's `triggers` block. Undeclared transitions do not exist in MADL.
