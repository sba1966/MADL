# flow

## Definition
A named, linear sequence of decks that together accomplish a single goal.
A flow has a declared entry point (the first deck in the sequence) and a
declared exit point (where the user lands after completing or abandoning
the flow). Within a flow, navigation is directional — the user moves
forward through the sequence and may or may not be able to go back.
A flow is the correct pattern for onboarding, checkout, setup wizards,
multi-step forms, and any task that has a clear beginning and end.

## WML Origin
New. WML's `<go>` and `<prev>` could express linear sequences, but WML
had no named concept for a bounded, purposeful sequence of cards/decks.
MADL names the flow explicitly because it carries semantic meaning —
a flow is a commitment from the user to complete a task, not just
a navigation path.

## ID Pattern
```
Pattern:  {app}.flow.{name}
Example:  trk.flow.onboard
          trk.flow.entry
          trk.flow.setup
```

### Rules for {name}
- Lowercase, alphanumeric, hyphens permitted
- Describes the goal of the flow, not its steps
- Should be a noun or noun phrase: `onboard`, `data-entry`, `account-setup`

## Declaration Format
```yaml
{app}.flow.{name}:
  name:   {human readable description}
  entry:  {deck_id}             # first deck in the flow
  exit:   {deck_id | card_id}   # destination on completion
  cancel: {deck_id | card_id}   # destination on abandonment (optional)
  decks:  [{deck_ids}]          # all decks that are part of this flow
```

## Example
```yaml
trk.flow.entry:
  name:   Data Entry Flow
  entry:  trk.d1
  exit:   trk.d3
  cancel: trk.d1.c1
  decks:  [trk.d1, trk.d2]
```

The decks in the flow are also declared in the atlas:
```yaml
trk.atlas:
  trk.d1:
    entry: trk.d1.c1
    exit:  trk.d1.c1
    nav:   trk.nav.stk1
  trk.d2:
    entry: trk.d2.c1
    exit:  trk.d1.c1
    nav:   trk.nav.stk1
```

## Notes
- A flow does not replace the atlas — decks in a flow are still declared
  in the atlas with their own `entry`, `exit`, and `nav`. The flow
  declaration is a higher-level grouping that names the sequence and
  declares its boundaries.
- The `cancel` destination is for when the user explicitly abandons
  the flow (taps Cancel, swipes down to dismiss). This may differ from
  `exit` (the completion destination).
- A flow's decks are typically owned by a `stack` navigator — forward
  navigation pushes decks, back navigation pops them. The flow's `exit`
  is reached when the final action in the last deck fires.
- Flows can be nested: a flow can contain a sub-flow. Declare the
  sub-flow as a separate `{app}.flow.{name}` and reference its `entry`
  deck as a step in the parent flow.
- Guards are particularly important in flows. A flow step should only
  proceed if the previous step's data is valid. Declare guards on the
  transition actions within each deck.
- Platform mappings: No direct equivalent — flows are a MADL concept
  that maps to a sequence of stack pushes in implementation. The flow
  declaration is a spec construct, not a runtime object.
