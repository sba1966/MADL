# trigger

## Definition
The named initiation point of an interaction. A trigger binds a gesture
or system event to a card, optionally to a specific element on that card,
and connects it to an action. A trigger answers the question: "what
causes something to happen here?". Every interaction in a MADL
specification begins with a trigger. Without a declared trigger,
no interaction exists in the specification.

## WML Origin
WML `<do>`. In WML, the `<do>` element declared that something should
happen in response to a user action (type="accept", type="prev", etc.).
MADL separates the initiation (trigger) from the operation (action)
because a single trigger may need to be described independently of what
it causes — for example, when documenting that a gesture exists on a
card before the action is decided.

## ID Pattern
```
Pattern:  {card}.t{n}
Example:  trk.d2.c1.t1
```

### Rules for {n}
- Positive integer, assigned sequentially within the parent card
- Stable and never reused
- Each card has its own `{n}` sequence

## Declaration Format
```yaml
{card}.t{n}:
  gesture:  {gesture_value}          # MUST — from closed gesture enumeration
  element:  {element_id}             # optional — binds trigger to specific element
  action:
    type:     {transition_type}      # MUST
    target:   {card_id | deck_id}    # MUST
    guard:    {condition}            # optional
    animation: {transition_type}    # optional override
```

## Example
```yaml
trk.d2.c1.t1:
  gesture:  tap
  element:  trk.d2.c1.s3.e1        # bound to the Save control
  action:
    type:   replace
    target: trk.d2.c3              # → card: saving
    guard:  form.valid == true

trk.d2.c1.t2:
  gesture:  tap
  element:  trk.d2.c1.s3.e2        # bound to the Cancel control
  action:
    type:   pop
    target: trk.d1.c1

trk.d2.c1.t3:
  gesture:  swipe-down
  action:
    type:   pop
    target: trk.d1.c1

trk.d1.c1.t4:
  gesture:  system-event            # no element — fired by service event
  action:
    type:   replace
    target: trk.d2.c1
    guard:  user.default_item != null
```

## Notes
- A trigger without an `element` binding fires anywhere on the card
  for gesture-based triggers, or fires when the system event arrives
  for `system-event` triggers. An element-bound trigger fires only
  when the gesture occurs on that element.
- Multiple triggers can share the same gesture on the same card if
  they are bound to different elements. Two unbound triggers with
  the same gesture on the same card is a conflict — declare only one.
- `system-event` triggers have no element binding. They fire when
  a service event arrives (declared in the services basket as
  `{service}.evt.{name}`). The connection between the event and
  the trigger is declared on the event node.
- Triggers are declared on cards, not on elements. An element does
  not own its trigger — the card does. This keeps interaction
  declarations at the card level, where they can be read as a
  complete interaction map for that card.
- When communicating a change to an AI agent, always reference the
  trigger ID: "modify trk.d2.c1.t1 to also guard on user.premium"
  is unambiguous. "Change the save button behaviour" is not.
