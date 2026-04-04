# exit

## Definition
The card or deck reached when the user leaves a deck via back navigation,
cancel, or task completion. The exit is declared per-deck in the atlas.
It answers the question: "if the user presses back on this deck, or taps
Cancel, where do they land?". Every deck should declare an exit.
Decks without a declared exit rely on the navigator's default back
behaviour, which may not match the intended specification.

## WML Origin
WML `<prev/>`. In WML, `<prev/>` returned the user to the previous card
in the browser's history. MADL makes the exit explicit and named because
modern navigators (stack, tabset, drawer) have different back behaviours,
and "the previous card in history" is not always the intended destination.
A modal deck that was presented from three different places should exit
to a specific, declared destination — not whichever deck happened to be
in the stack before it was opened.

## ID Pattern
```
Pattern:  declared in atlas as a property of {deck_id}
Value:    {deck_id | card_id}
Example:  exit: trk.d1.c1
```

Exit is not a node with its own ID — it is a property declared on a
deck within the atlas.

## Declaration Format
```yaml
{app}.atlas:
  {deck_id}:
    exit: {deck_id | card_id}     # SHOULD — recommended for all decks
```

### Exit value types

| Value type  | Meaning                                           |
|-------------|---------------------------------------------------|
| `{deck_id}` | Navigate to the entry card of that deck           |
| `{card_id}` | Navigate to that specific card in its deck        |

## Example
```yaml
trk.atlas:
  trk.d2:
    entry: trk.d2.c1
    exit:  trk.d1.c1     # back from Data Entry goes to Item Selection default
    nav:   trk.nav.stk1

  trk.d3:
    entry: trk.d3.c1
    exit:  trk.d2.c1     # back from History goes to Data Entry default
    nav:   trk.nav.tab1
```

A trigger that explicitly invokes exit behaviour:
```yaml
trk.d2.c2.t2:
  gesture: tap
  element: trk.d2.c2.s3.e2     # Cancel button
  action:
    type:   pop
    target: trk.d1.c1           # same as the atlas exit — explicit is better
```

## Notes
- Declaring `exit` in the atlas and also declaring explicit `pop`/`replace`
  transitions on cancel buttons is not redundant — it is good practice.
  The atlas exit is the fallback for the back gesture. The trigger exit
  is the declared behaviour for the Cancel button. They should agree.
- When a deck is reachable from multiple places (e.g. a shared settings
  deck opened from both a tab and a flow), the atlas exit should point
  to the most common or sensible default destination. Specific triggers
  can override this for specific entry paths.
- Modal decks (presented with `modal-present`) should always declare
  an exit pointing to the deck that presented them. The system
  `modal-dismiss` transition also handles this, but an explicit exit
  makes the intention clear.
- Do not leave the exit blank on decks that are not the root of a stack.
  A missing exit is an ambiguous specification — different platforms
  and navigators will behave differently, and an AI coding agent will
  be forced to guess.
- The exit of the root deck in a stack (the bottom-most deck that cannot
  be popped) is conventionally itself:
  `exit: {root_deck}.c1` — meaning "back at the root does nothing".
