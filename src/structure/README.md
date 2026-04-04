# STRUCTURE

The addressable hierarchy of the application.
All other baskets reference nodes defined here.

**Centre basket.** Every ID in MADL derives from a structure node.

## Terms in this basket

| Term | ID Pattern | Definition |
|---|---|---|
| [app](./app.md) | `{app_id}` | Root container. One per product. |
| [deck](./deck.md) | `{app}.d{n}` | Full-viewport destination. One visible at a time. |
| [card](./card.md) | `{deck}.c{n}` | One named state of a deck. |
| [layer](./layer.md) | `{app}.l{n}` | Persistent chrome shared across decks. |
| [slot](./slot.md) | `{card}.s{n}` | Named region within a card. |
