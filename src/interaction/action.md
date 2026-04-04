# action

## Definition
The named operation that executes when a trigger fires. An action declares
what happens: which transition type is used, which card or deck is the
target, and whether a guard condition must be satisfied. There is exactly
one action per trigger. The action is the "then" in the trigger's "when".
An action without a guard always executes when its trigger fires.
An action with a guard only executes if the guard evaluates true.

## WML Origin
WML `<do>` type attribute and child `<go>` element. In WML, the `<do>`
element combined trigger and action in a single construct. MADL separates
them because the initiation (trigger) and the operation (action) have
different concerns: a trigger describes what the user does, an action
describes what the system does in response. Separating them allows a
trigger to be documented before its action is decided, and allows the
same action pattern to be described consistently across many triggers.

## ID Pattern
```
Pattern:  {trigger}.a
Example:  trk.d2.c1.t1.a
```

Each trigger has exactly one action. The `.a` suffix is fixed — there
is no `{n}` because there is only ever one action per trigger.

## Declaration Format
```yaml
{trigger}.a:                          # or declared inline on the trigger
  type:      {transition_type}        # MUST — from closed transition enumeration
  target:    {card_id | deck_id}      # MUST
  guard:     {condition}              # optional boolean expression
  animation: {transition_type}        # optional — overrides default animation
```

In practice, the action is almost always declared inline on its trigger
rather than as a separate block. Both forms are valid:

```yaml
# inline form (preferred)
trk.d2.c1.t1:
  gesture: tap
  element: trk.d2.c1.s3.e1
  action:
    type:   replace
    target: trk.d2.c3
    guard:  form.valid == true

# explicit form (when referencing the action separately)
trk.d2.c1.t1.a:
  type:   replace
  target: trk.d2.c3
  guard:  form.valid == true
```

## Guard expression syntax

Guards are boolean expressions. They gate the action — if the guard
evaluates false, the action does not execute and the user remains on
the current card.

```
Operators:  ==  !=  >  <  >=  <=  &&  ||  !
Examples:
  form.valid == true
  user.authenticated == true && session.active == true
  input.length > 0
  !form.errors
  entry.count >= 1
```

Guard values reference runtime data by dot-notation path. The path
resolves against the current data context of the card. Specific
binding of guard paths to data sources is an implementation concern —
MADL declares the condition, not the binding mechanism.

## Example
```yaml
# Action with guard — only proceeds if form is valid
trk.d2.c2.t1:
  gesture: tap
  element: trk.d2.c2.s3.e1
  action:
    type:   replace
    target: trk.d2.c3
    guard:  form.valid == true

# Action without guard — always executes on tap
trk.d2.c2.t2:
  gesture: tap
  element: trk.d2.c2.s3.e2
  action:
    type:   pop
    target: trk.d1.c1

# Action with compound guard
trk.d1.c1.t1:
  gesture: system-event
  action:
    type:   replace
    target: trk.d2.c1
    guard:  user.default_item != null && app.initialized == true

# Action with animation override
trk.d3.c1.t1:
  gesture: swipe-left
  action:
    type:      replace
    target:    trk.d4
    animation: fade
```

## Notes
- An action with a failing guard is silent — it produces no visible
  effect and no error. If feedback is required when a guard fails
  (e.g. showing a validation error), that feedback is a separate
  trigger/action on the same card responding to the same gesture
  with the inverse guard condition.
- The `animation` field overrides the default animation implied by
  the transition type. `push` defaults to a right-to-left slide.
  `pop` defaults to a left-to-right slide. Override only when the
  default is wrong for the specific transition.
- An action always has exactly one target. Conditional routing
  (different targets based on different conditions) is expressed
  as multiple triggers with different guards, not as a single
  action with branching.
- The action is the most important node for an AI coding agent
  to read — it contains the complete specification of what happens
  at each interaction point. Keep action declarations unambiguous
  and never omit the guard when one is required.
