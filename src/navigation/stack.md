# stack

## Definition
A navigator that maintains a history of visited decks as a push-down stack.
Navigating to a new deck pushes it onto the stack. The back gesture or action
pops the current deck and returns to the previous one. The user always sees
the deck at the top of the stack. A stack is the correct navigator for
drill-down flows where the user can retrace their path.

## WML Origin
New. WML navigation was implicitly stack-based via `<go>` (push) and
`<prev>` (pop), but WML had no named navigator concept. MADL makes the
navigator explicit and named so that multiple stacks, tab sets, and drawers
can coexist within the same app and each deck can be assigned to exactly
one navigator.

## ID Pattern
```
Pattern:  {app}.nav.stk{n}
Example:  trk.nav.stk1
```

## Declaration Format
```yaml
{app}.nav.stk{n}:
  type:  stack
  root:  {deck_id}          # the bottom-most deck — cannot be popped
```

## Example
```yaml
trk.nav.stk1:
  type: stack
  root: trk.d1
```

Atlas entries for decks owned by this stack:
```yaml
trk.atlas:
  trk.d1:
    entry: trk.d1.c1
    nav:   trk.nav.stk1
  trk.d2:
    entry: trk.d2.c1
    exit:  trk.d1.c1
    nav:   trk.nav.stk1
```

Transition declarations that use this navigator's push/pop:
```yaml
trk.d1.c1.t1:
  gesture: tap
  element: trk.d1.c1.s1.e1
  action:
    type:   push
    target: trk.d2
```

## Notes
- A stack MUST declare a `root` deck. The root cannot be popped — it is
  the floor of the stack. Attempting to pop the root is a no-op or exits
  the app, depending on platform behaviour.
- Each tab in a tabset typically has its own stack. This is the standard
  pattern: one `tabset` navigator containing N tabs, each tab being the
  root of its own `stack` navigator.
- Transition types used with a stack navigator:
  `push` — add deck to stack
  `pop`  — remove current deck, return to previous
  `replace` — swap current deck without changing stack depth
- The back gesture (`gesture: back`) implicitly fires a `pop` transition.
  It does not need to be declared unless a guard is required.
- Platform mappings: UINavigationController (iOS),
  FragmentManager back stack (Android), Stack.Navigator (React Navigation).
