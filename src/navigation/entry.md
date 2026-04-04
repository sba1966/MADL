# entry

## Definition
The default card displayed when a deck is first opened. Every deck must
declare an entry card. When a navigator transitions to a deck, it shows
the entry card unless a specific card is explicitly targeted by the
transition. The entry card is the "ground state" of a deck — what the
user sees before any interaction has occurred within that deck.

## WML Origin
WML `<go href="..."/>`. In WML, navigating to a deck without specifying
a card always showed the first `<card>` element in the file, which was
the implicit entry. MADL makes the entry explicit and named, because
in a multi-card deck the "first" card in a file is an accident of
authoring order, not a specification decision.

## ID Pattern
```
Pattern:  declared in atlas as a property of {deck_id}
Value:    {card_id}
Example:  entry: trk.d2.c1
```

Entry is not a node with its own ID — it is a property declared on a
deck within the atlas.

## Declaration Format
```yaml
{app}.atlas:
  {deck_id}:
    entry: {card_id}     # MUST — no default
```

## Example
```yaml
trk.atlas:
  trk.d2:
    entry: trk.d2.c1     # the default card is card 1 (name: default)
    exit:  trk.d1.c1
    nav:   trk.nav.stk1

  trk.d3:
    entry: trk.d3.c1     # history deck opens to loaded state if data exists
    exit:  trk.d2.c1
    nav:   trk.nav.tab1
```

A transition that overrides entry and targets a specific card directly:
```yaml
trk.d1.c1.t2:
  gesture: system-event
  guard:   user.default_item != null
  action:
    type:   replace
    target: trk.d2.c2    # goes directly to card 2 (editing), not entry
```

## Notes
- The entry card is the card shown when no other card is specified.
  It is the default, not the only card reachable on first open.
  Transitions can target any card in a deck directly.
- The entry card is almost always `{deck}.c1` — the first card created
  in the deck, which typically has the `default` name. This is a
  convention, not a rule. The entry can be any card.
- Changing the entry card of a deck is a spec change that must be
  reflected in the atlas. It is not an implementation detail.
- In conditional navigation (e.g. "if the user has a default item,
  skip to the data entry screen"), the conditional logic lives in a
  `trigger` with a `guard` — the entry card itself does not change.
  The navigator arrives at the entry card, and an immediate
  `system-event` trigger with a guard redirects if the condition is met.
- Do not confuse `entry` (the default card of a deck) with `flow.entry`
  (the first deck of a flow). These are different concepts at different
  levels of the hierarchy.
