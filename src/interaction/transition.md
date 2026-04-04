# transition

## Definition
The movement from one card or deck to another, declared as the `type`
property of an action. A transition describes how the navigator moves —
the direction, the animation metaphor, and the stack relationship between
source and target. Transitions are not objects with their own IDs; they
are typed values on actions. The closed enumeration of transition types
is the complete vocabulary for describing movement in MADL.

## WML Origin
New as an explicit concept. WML's `<go>` was always a forward transition
and `<prev>` was always a back transition — the type was implicit in the
element. MADL names transition types explicitly because modern navigators
support many movement patterns (push, pop, replace, modal, sheet, fade)
that carry different semantic and visual meanings and must be specified
precisely.

## ID Pattern
Transitions do not have IDs. They are values declared on actions:
```yaml
{trigger}.action.type: {transition_type}
```

## Transition type enumeration (closed — exhaustive)

| Type            | Direction  | Stack effect          | Typical animation          |
|-----------------|------------|-----------------------|----------------------------|
| `push`          | forward    | adds to stack         | slide in from right        |
| `pop`           | backward   | removes from stack    | slide out to right         |
| `replace`       | neutral    | no stack change       | cross-fade or direct swap  |
| `modal-present` | up         | new modal layer       | slide up from bottom       |
| `modal-dismiss` | down       | removes modal layer   | slide down to bottom       |
| `sheet-up`      | up         | partial overlay       | partial slide from bottom  |
| `sheet-down`    | down       | removes sheet         | slide down                 |
| `fade`          | neutral    | no stack change       | cross-fade                 |
| `none`          | neutral    | no stack change       | instant, no animation      |

## Declaration Format
```yaml
{trigger_id}:
  gesture: {gesture}
  action:
    type:      {transition_type}    # MUST — from table above
    target:    {card_id | deck_id}
    guard:     {condition}          # optional
    animation: {transition_type}   # optional — overrides default animation
```

## Example
```yaml
# Forward navigation — drill into detail
trk.d1.c1.t1:
  gesture: tap
  element: trk.d1.c1.s1.e1
  action:
    type:   push
    target: trk.d2

# Back navigation — return to previous
trk.d2.c1.t1:
  gesture: back
  action:
    type:   pop
    target: trk.d1.c1

# Modal presentation — interrupt with a focused task
trk.d2.c1.t2:
  gesture: tap
  element: trk.d2.c1.s1.e3
  action:
    type:   modal-present
    target: trk.d8

# Sheet — partial overlay without losing context
trk.d3.c1.t1:
  gesture: tap
  element: trk.d3.c1.s2.e1
  action:
    type:   sheet-up
    target: trk.d9.c1

# Replace — swap card within deck, no stack change
trk.d2.c1.t3:
  gesture: system-event
  action:
    type:   replace
    target: trk.d2.c3
    guard:  save.complete == true

# Fade — neutral transition, no directional implication
trk.d1.c1.t4:
  gesture: system-event
  action:
    type:   fade
    target: trk.d2.c1
    guard:  app.initialized == true
```

## Choosing the right transition type

```
User drills into more detail              →  push
User goes back to previous context        →  pop
Application changes card condition        →  replace
Task requires full focus, can be aborted  →  modal-present
Dismissing a modal                        →  modal-dismiss
Additional options without losing context →  sheet-up
Dismissing a sheet                        →  sheet-down
App state change with no direction        →  fade
Immediate swap, no animation needed       →  none
```

## Notes
- `push` and `pop` are stack operations. Using them outside a stack
  navigator is undefined behaviour — use `replace` or `fade` instead.
- `replace` does not add to or remove from the stack. It is the correct
  transition for card-level changes within a deck (e.g. moving from
  the `default` card to the `loading` card after the user taps a button).
- `modal-present` and `modal-dismiss` are paired. Every `modal-present`
  must have a corresponding `modal-dismiss` path, either via a trigger
  on the modal deck or via the modal deck's declared exit.
- `sheet-up` and `sheet-down` are paired in the same way.
- The `animation` override field accepts any transition type value
  as an animation name. It does not change the stack behaviour —
  it only changes the visual motion. A `replace` with
  `animation: push` replaces without adding to the stack but
  animates as if pushing.
- Adding a new transition type requires a spec change. Do not
  invent transition types — if none of the nine fit, open an issue.
