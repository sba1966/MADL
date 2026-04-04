# drawer

## Definition
A navigator whose deck set is hidden off-screen and revealed by a gesture
or a trigger. The drawer slides in from the left or right edge, presenting
its navigation destinations as a list or panel. It is typically used for
secondary navigation — settings, account management, help, or any
destination that is needed occasionally rather than constantly.
A drawer is not the primary way to move through the app; it is an
escape hatch to destinations that don't warrant a tab.

## WML Origin
New. WML had no drawer concept. The drawer pattern emerged in the
smartphone era as an alternative to tabs for applications with many
destinations that cannot all be represented in a tab bar.

## ID Pattern
```
Pattern:  {app}.nav.drw{n}
Example:  trk.nav.drw1
```

## Declaration Format
```yaml
{app}.nav.drw{n}:
  type:  drawer
  side:  left | right          # which edge it slides from
  items:
    - deck:  {deck_id}
      label: {menu item label}
```

## Example
```yaml
trk.nav.drw1:
  type: drawer
  side: left
  items:
    - deck:  trk.d8
      label: Settings
    - deck:  trk.d9
      label: About
    - deck:  trk.d10
      label: Help
```

Trigger to open the drawer (typically on a layer element):
```yaml
trk.l1.s1.e3:
  type:  control
  label: Menu
trk.l1.s1.e3.t1:
  gesture: tap
  action:
    type:   modal-present
    target: trk.nav.drw1
```

Gesture to open the drawer:
```yaml
trk.d1.c1.t2:
  gesture: swipe-right
  action:
    type:   modal-present
    target: trk.nav.drw1
```

## Notes
- A drawer is revealed by `modal-present` and dismissed by `modal-dismiss`
  or by the user tapping outside the drawer panel.
- The drawer itself is not a deck — it is a navigator. It contains decks.
  When the user selects an item from the drawer, they navigate to that deck.
- A drawer is typically triggered from a hamburger icon (`≡`) on a layer,
  or by a swipe-right gesture from the left edge of the screen.
- Drawers are less discoverable than tabs. Use a drawer when:
  - There are more destinations than can fit in a tab bar (> 5)
  - The destinations are secondary and infrequently visited
  - The primary navigation is a stack and tabs are not appropriate
- Platform mappings: UISplitViewController side panel (iOS),
  NavigationDrawer (Android Material),
  Drawer.Navigator (React Navigation).
