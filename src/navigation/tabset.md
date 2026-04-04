# tabset

## Definition
A navigator that presents a fixed set of decks as parallel, persistent
destinations. The user can switch between tabs at any time without losing
the state of any tab. Each tab maintains its own navigation stack
independently. A tabset is the correct navigator for top-level destinations
that the user needs equal, permanent access to — not a sequence to be
completed, but a set of places to inhabit.

## WML Origin
WML-adjacent. WML had no tabset concept, but the WAP era's card-based
navigation implied parallel card sets within a deck. MADL names this pattern
explicitly because the tabset is one of the two most common navigators in
modern mobile applications (alongside the stack) and must be addressable
in the specification.

## ID Pattern
```
Pattern:  {app}.nav.tab{n}
Example:  trk.nav.tab1
```

## Declaration Format
```yaml
{app}.nav.tab{n}:
  type: tabset
  tabs:
    - deck:  {deck_id}
      label: {tab label}
      icon:  {icon name}     # optional
```

## Example
```yaml
trk.nav.tab1:
  type: tabset
  tabs:
    - deck:  trk.d3
      label: "-1"
    - deck:  trk.d4
      label: "-2"
    - deck:  trk.d5
      label: "-3"
    - deck:  trk.d6
      label: "-4"
    - deck:  trk.d7
      label: "-5"
```

Atlas entries for decks owned by this tabset:
```yaml
trk.atlas:
  trk.d3:
    entry: trk.d3.c1
    exit:  trk.d2.c1
    nav:   trk.nav.tab1
  trk.d4:
    entry: trk.d4.c1
    exit:  trk.d2.c1
    nav:   trk.nav.tab1
```

## Notes
- Each deck in a tabset MUST be listed in the `tabs:` array in display order.
  The order in the array determines the order of tabs in the UI.
- A tabset renders a persistent tab bar (typically at the bottom on iOS,
  at the bottom or as a navigation rail on Android). This tab bar is
  modelled as a `layer` in MADL — declare it separately as `{app}.l{n}`
  and list which decks it appears on.
- Switching tabs does not push or pop a stack. It is a `replace`-equivalent
  transition at the navigator level. The stack within each tab is preserved
  — the user returns to wherever they left off in each tab.
- A tabset typically has 2–5 tabs. More than 5 tabs on mobile is a UX
  problem, not a MADL problem — but MADL does not enforce a limit.
- Do not use a tabset for sequential flows. Use a `flow` or `stack` instead.
  Tabs imply equal, parallel, non-sequential destinations.
- Platform mappings: UITabBarController (iOS),
  BottomNavigationView / NavigationRail (Android Material),
  Tab.Navigator (React Navigation).
