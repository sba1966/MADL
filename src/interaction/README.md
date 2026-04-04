# INTERACTION

What the user does and what happens as a result.

**Top-right basket.** Close to the user. Triggers, actions, transitions.

## Terms in this basket

| Term | ID Pattern | Definition |
|---|---|---|
| [trigger](./trigger.md) | `{card}.t{n}` | Gesture or system event initiating an action. |
| [action](./action.md) | `{trigger}.a` | Named operation bound to a trigger. |
| [transition](./transition.md) | declared on action | Movement between cards or decks. |
| [guard](./guard.md) | declared on action | Condition gating a transition. |
| [gesture](./gesture.md) | value on trigger | Physical trigger type. Closed enumeration. |
