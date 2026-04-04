# deck

## Definition
A full-viewport destination in the application. Exactly one deck is visible
to the user at any given time. A deck is the primary unit of navigation — the
"where" in the question "where is the user?". A deck may contain one or more
cards, each representing a different named condition of that destination.

## WML Origin
WML `<card>` container. In WML, a `.wml` file was called a deck and contained
one or more `<card>` elements. MADL restores the deck/card distinction that
WML implied but did not always make explicit — a deck is the destination, a
card is the state of that destination.

## ID Pattern
```
Pattern:  {app}.d{n}
Example:  trk.d2
```

### Rules for {n}
- Positive integer, assigned sequentially at deck creation
- Stable — never changes after assignment
- Never reused — if deck `trk.d3` is retired, `trk.d4` becomes the next new deck
- The integer has no inherent meaning — `d2` is not "second in importance",
  it is "second created"

## Declaration Format
```yaml
{app}.d{n}:
  name:   {human readable description}
  cards:
    {card_id}: ...
```

The deck declaration lives inside the `decks:` block of the app specification.
The routing of the deck (which navigator owns it, what its entry and exit are)
is declared in the `atlas`, not in the deck itself.

## Example
```yaml
trk.d2:
  name: Data Entry
  cards:
    trk.d2.c1:
      name: default
    trk.d2.c2:
      name: editing
    trk.d2.c3:
      name: saving
    trk.d2.c4:
      name: error
```

## Notes
- A deck MUST have at least one card.
- A deck MUST declare an `entry` card in the atlas — the card shown on
  first arrival at this deck.
- A deck SHOULD declare an `exit` target in the atlas — the destination
  reached when the user navigates back, cancels, or completes the deck's task.
- Decks are not inherently ordered. `d1`, `d2`, `d3` have no implied sequence
  unless connected by transitions in the atlas.
- A deck corresponds roughly to: a UIViewController (iOS), an Activity
  (Android), or a route file (React Native / Expo Router). MADL is
  platform-neutral — the deck concept maps to all of these without specifying
  which one is used in implementation.
- Do not name decks after their card conditions. Name them after their purpose:
  "Data Entry", not "Form Screen" or "Editing State".
