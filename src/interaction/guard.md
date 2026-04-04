# guard

## Definition
A boolean condition declared on an action that must evaluate true for the
action to execute. A guard gates a transition — if the guard is false,
the trigger fires but the action does not execute, and the user remains
on the current card. Guards encode business rules and validation
requirements directly in the specification, making them visible to both
human readers and AI coding agents without requiring inspection of
implementation code.

## WML Origin
New. WML had no guard concept — conditional navigation was implemented
in WScript or WTAI procedural code, invisible to the deck structure.
MADL makes conditions first-class specification nodes because the
question "under what condition does this transition happen?" is as
important as the question "where does this transition go?".

## ID Pattern
Guards do not have IDs. They are string values declared on actions:
```yaml
{trigger}.action.guard: {boolean_expression}
```

## Expression syntax

```
Comparison:   ==   !=   >   <   >=   <=
Logical:      &&   ||   !
Grouping:     ( )

Path format:  {context}.{property}
              form.valid
              user.authenticated
              entry.count
              session.active
              input.length
```

Path segments reference runtime data by dot-notation. The left side
of the path is the data context (form, user, session, entry, etc.).
The right side is the property within that context. MADL declares
the condition; implementation binds the path to actual data.

## Standard guard patterns

These patterns recur across most applications. Use these names
consistently so that AI agents and collaborators recognise them.

| Pattern                           | Meaning                                  |
|-----------------------------------|------------------------------------------|
| `form.valid == true`              | All required fields pass validation      |
| `user.authenticated == true`      | User has an active session               |
| `entry.count > 0`                 | At least one data record exists          |
| `user.default_item != null`       | A default selection has been made        |
| `network.available == true`       | Device has a network connection          |
| `input.length > 0`                | Input field is not empty                 |
| `save.complete == true`           | An async save operation has finished     |
| `!form.errors`                    | No validation errors present             |
| `user.premium == true`            | User has a premium account               |

## Example
```yaml
# Simple validity guard
trk.d2.c2.t1:
  gesture: tap
  element: trk.d2.c2.s3.e1
  action:
    type:   replace
    target: trk.d2.c3
    guard:  form.valid == true

# Compound guard — multiple conditions
trk.d1.c1.t1:
  gesture: system-event
  action:
    type:   replace
    target: trk.d2.c1
    guard:  user.default_item != null && app.initialized == true

# Inverse guard — show error if invalid
trk.d2.c2.t2:
  gesture: tap
  element: trk.d2.c2.s3.e1
  action:
    type:   replace
    target: trk.d2.c4             # error card
    guard:  form.valid == false

# Existence guard
trk.d3.c2.t1:
  gesture: system-event
  action:
    type:   replace
    target: trk.d3.c1             # loaded card
    guard:  entry.count > 0

# Negation guard
trk.d3.c1.t1:
  gesture: system-event
  action:
    type:   replace
    target: trk.d3.c2             # empty card
    guard:  "!entry.data"
```

## Notes
- A failing guard is silent. If the guard fails and the user needs
  feedback (e.g. "please fill in all fields"), that feedback is a
  second trigger on the same gesture with the inverse guard, targeting
  a card or overlay that shows the error.
- Guards on `system-event` triggers are evaluated when the event
  arrives. If the guard fails, the event is consumed but the transition
  does not fire.
- Do not use guards to encode access control or authentication in
  isolation. A guard of `user.authenticated == true` should be paired
  with a redirect trigger: if the guard fails, a second trigger with
  `user.authenticated == false` navigates to the login deck.
- Guards reference runtime state by convention. The exact binding
  of guard path expressions to data models is an implementation
  concern. MADL specifies the condition; the implementation
  resolves it.
- When two triggers on the same card share the same gesture and
  the same element, their guards must be mutually exclusive —
  exactly one should fire for any given state. Overlapping guards
  on the same gesture/element pair is a specification error.
