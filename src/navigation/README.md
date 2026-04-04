# NAVIGATION

How the user moves between decks and cards.

**Top-left basket.** Closest to user intent. Spatial and directional.

## Terms in this basket

| Term | ID Pattern | Definition |
|---|---|---|
| [atlas](./atlas.md) | `{app}.atlas` | Complete map of all decks, cards, transitions. |
| [stack](./stack.md) | `{app}.nav.stk{n}` | Back-enabled history stack navigator. |
| [tabset](./tabset.md) | `{app}.nav.tab{n}` | Parallel persistent destinations navigator. |
| [drawer](./drawer.md) | `{app}.nav.drw{n}` | Hidden off-screen navigator. |
| [flow](./flow.md) | `{app}.flow.{name}` | Named linear deck sequence. |
| [entry](./entry.md) | declared in atlas | Default card on first deck open. |
| [exit](./exit.md) | declared in atlas | Target on back/cancel/complete. |
