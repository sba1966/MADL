# atlas

## Definition
The complete map of an application. The atlas declares every deck, its entry
card, its exit target, and the navigator that owns it. It is the single
document that answers the question: "given any deck, where does the user
come from and where can they go?". There is exactly one atlas per app.
The atlas is the authoritative routing table — if a transition is not
declared in the atlas, it does not exist in the specification.

## WML Origin
New. WML had no equivalent — navigation in WML was implicit, declared inline
on individual cards using `<go>` and `<prev>`. MADL externalises routing into
a dedicated map because modern applications have enough decks and transitions
that inline routing becomes untrackable. The word "atlas" is chosen over
"map" (too generic), "router" (implies implementation), and "sitemap"
(implies web) because an atlas is a collection of maps with a consistent
coordinate system — which is exactly what MADL IDs provide.

## ID Pattern
```
Pattern:  {app}.atlas
Example:  trk.atlas
```

The atlas is a singleton. There is exactly one per app.

## Declaration Format
```yaml
{app}.atlas:
  {deck_id}:
    entry: {card_id}
    exit:  {deck_id | card_id}
    nav:   {navigator_id}
```

### Field definitions

| Field   | Required | Value                              |
|---------|----------|------------------------------------|
| `entry` | MUST     | ID of the card shown on first open |
| `exit`  | SHOULD   | ID of deck or card reached on back/cancel/complete |
| `nav`   | MUST     | ID of the navigator that owns this deck |

## Example
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

  trk.d3:
    entry: trk.d3.c1
    exit:  trk.d2.c1
    nav:   trk.nav.tab1

  trk.d4:
    entry: trk.d4.c1
    exit:  trk.d2.c1
    nav:   trk.nav.tab1

  trk.d5:
    entry: trk.d5.c1
    nav:   trk.nav.tab1

  trk.d6:
    entry: trk.d6.c1
    nav:   trk.nav.tab1

  trk.d7:
    entry: trk.d7.c1
    nav:   trk.nav.tab1
```

## Notes
- The atlas is not a flow diagram. It declares what is possible, not what
  is likely. The sequence of user actions is described in the flow diagram
  (PlantUML `app_flow.puml`). The atlas is the routing table beneath it.
- Every deck in the app MUST have an entry in the atlas. A deck with no
  atlas entry cannot be reached by the navigator.
- `exit` is optional but strongly recommended. Without a declared exit,
  the navigator's default back behaviour applies — which may not be
  what the spec intends.
- The atlas should be the first document written when starting a new
  MADL specification. It forces enumeration of all destinations before
  any detail is added.
- When an AI coding agent reads the atlas, it can derive the complete
  navigation graph without reading any other file.
