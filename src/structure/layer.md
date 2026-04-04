# layer

## Definition
A persistent structural element rendered across multiple decks simultaneously.
A layer is not a deck — it does not occupy the full viewport and is not a
navigation destination. It is chrome: UI that remains visible as the user
moves between decks, providing persistent navigation controls, identity, or
context. The most common examples are the navigation bar at the top of the
screen and the tab bar at the bottom.

## WML Origin
New. WML had no concept of persistent chrome — every card filled the entire
viewport. The `layer` term is introduced because modern mobile applications
require a vocabulary for UI that exists outside the deck/card lifecycle.

The term `layer` is chosen over `layout` (implies arrangement), `chrome`
(implies styling), and `shell` (too architectural) because it describes a
structural stratum — something that sits on a different plane from the decks
below it, persists independently, and contains its own addressable elements.

## ID Pattern
```
Pattern:  {app}.l{n}
Example:  trk.l1
```

## Declaration Format
```yaml
{app}.l{n}:
  name:   {description}
  type:   nav-bar | tab-bar | drawer-bar | custom
  decks:  [{deck_ids}]          # which decks this layer appears on
  slots:
    {slot_id}: ...
```

## Example
```yaml
trk.l1:
  name:  Main Navigation Bar
  type:  nav-bar
  decks: [trk.d2, trk.d3, trk.d4, trk.d5, trk.d6, trk.d7]
  slots:
    trk.l1.s1:
      elements:
        trk.l1.s1.e1:
          type:  control
          label: Back
        trk.l1.s1.e2:
          type:  label
          label: "{deck.name}"

trk.l2:
  name:  History Tab Bar
  type:  tab-bar
  decks: [trk.d3, trk.d4, trk.d5, trk.d6, trk.d7]
  slots:
    trk.l2.s1:
      elements:
        trk.l2.s1.e1:
          type:  control
          label: "-1"
        trk.l2.s1.e2:
          type:  control
          label: "-2"
        trk.l2.s1.e3:
          type:  control
          label: "-3"
        trk.l2.s1.e4:
          type:  control
          label: "-4"
        trk.l2.s1.e5:
          type:  control
          label: "-5"
```

## Notes
- A layer is declared at the app level, not inside a deck. It spans decks.
- The `decks:` list declares which decks the layer appears on. A layer
  not listed for a deck does not appear on that deck.
- Layer elements follow the same ID pattern as card elements: slots contain
  elements, elements have types, controls have triggers. The parent path
  is `{app}.l{n}` rather than `{deck}.d{n}.c{n}`.
- Layers have no `entry` or `exit` — they are not navigated to or from.
- Layers do not have cards — they do not change condition based on navigation.
  If a layer element must change based on context (e.g. a back button that
  only appears on some decks), use `visible-if` on the element, not a
  separate layer.
- Platform mappings: UINavigationBar / UITabBar (iOS), TopAppBar /
  NavigationBar (Android Material), Stack/Tab header (React Navigation).
  MADL `layer` maps to all of these without specifying implementation.
