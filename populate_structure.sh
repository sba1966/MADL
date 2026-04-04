#!/usr/bin/env bash
# =============================================================================
# MADL — populate src/structure basket
# Run from the MADL repository root:
#   chmod +x populate_structure.sh
#   ./populate_structure.sh [target_directory]
# Default target: ./src/structure
# =============================================================================

set -e

TARGET="${1:-./src/structure}"

if [ ! -d "$TARGET" ]; then
  echo "  Directory $TARGET does not exist. Run scaffold_madl.sh first."
  exit 1
fi

echo ""
echo "  MADL — populating STRUCTURE basket"
echo "  Target: $TARGET"
echo ""

# =============================================================================
# app.md
# =============================================================================
cat > "$TARGET/app.md" << 'EOF'
# app

## Definition
The root container of a MADL-described application. There is exactly one `app`
per product. Every other node in the specification derives its ID from the app
identifier. The `app` node is the single point of truth for the application's
identity and its top-level registry of navigators, layers, and services.

## WML Origin
New. WML had no explicit root container concept — a WML file was implicitly
scoped to a single deck set. MADL makes the root explicit because modern
applications span multiple navigators, layers, and service registries that all
require a common ancestor for ID derivation.

## ID Pattern
```
Pattern:  {app_id}
Example:  trk
```

### Rules for {app_id}
- 2–6 characters, lowercase alphanumeric only
- Unique per product — no two products in the same workspace share an ID
- Chosen once at project start and never changed
- Should be a meaningful abbreviation of the product name

| Product name     | Suggested app_id |
|------------------|------------------|
| Tracker          | trk              |
| Finance Manager  | fnmg             |
| Daily Log        | dlog             |
| Health Monitor   | hlth             |

## Declaration Format
```yaml
{app_id}:
  name:     {human readable product name}
  version:  {semver string}
  platform: ios | android | cross
```

## Example
```yaml
trk:
  name:     Tracker
  version:  0.1.0
  platform: cross
```

## Notes
- The `app` node itself has no visual representation. It is a namespace root.
- All navigators, layers, decks, and services MUST be declared as children
  of the app — either directly or by reference through the atlas.
- When referencing the app in conversation with a collaborator or AI agent,
  use only the `{app_id}`. Never use the human-readable name as an identifier.
  "Change something in trk" is unambiguous. "Change something in Tracker" is not.
EOF

echo "  written: app.md"

# =============================================================================
# deck.md
# =============================================================================
cat > "$TARGET/deck.md" << 'EOF'
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
EOF

echo "  written: deck.md"

# =============================================================================
# card.md
# =============================================================================
cat > "$TARGET/card.md" << 'EOF'
# card

## Definition
One named configuration of a deck. A card represents a specific condition
in which a deck can exist — what the user sees and what interactions are
available when the deck is in that condition. Multiple cards share the same
deck (same route, same destination) but present different appearances and
behaviours. The user navigates between decks; the application moves between
cards within a deck in response to data and actions.

## WML Origin
WML `<card>`. In WML, each `<card>` element inside a deck file represented
one visible "page" of content. MADL preserves this exactly: a card is the
atomic visible unit within a deck. The key clarification MADL adds is that
cards within a deck share a route — they are conditions of the same
destination, not separate destinations.

## ID Pattern
```
Pattern:  {deck}.c{n}
Example:  trk.d2.c3
```

### Rules for {n}
- Positive integer, assigned sequentially at card creation within its parent deck
- Stable and never reused
- Each deck has its own `{n}` sequence — `trk.d1.c1` and `trk.d2.c1` are
  different cards; the `c1` in each refers to the first card of its respective deck

## Declaration Format
```yaml
{card_id}:
  name:   {standard_card_name | custom_name}
  slots:
    {slot_id}: ...
  triggers:
    {trigger_id}: ...
  overlays:
    {overlay_id}: ...
```

## Standard Card Names

Use these names consistently. They are the closed vocabulary for card conditions.
Custom names are permitted but must be documented in the deck's declaration.

| Name      | Condition                                   |
|-----------|---------------------------------------------|
| `default` | Normal loaded state. Use when no other applies. |
| `empty`   | No data to display. First-use or post-clear.|
| `loading` | Async operation in progress.                |
| `loaded`  | Data present and rendered.                  |
| `error`   | A failure occurred.                         |
| `editing` | User is actively modifying data.            |
| `saving`  | Write operation in flight.                  |
| `success` | Operation completed successfully.           |

## Example
```yaml
trk.d2.c1:
  name: default
  slots:
    trk.d2.c1.s1:
      elements:
        trk.d2.c1.s1.e1:
          type: label
          label: Enter your data below
    trk.d2.c1.s2:
      elements:
        trk.d2.c1.s2.e1:
          type: field
          placeholder: Data value
        trk.d2.c1.s2.e2:
          type: control
          label: Save
  triggers:
    trk.d2.c1.t1:
      gesture: tap
      element: trk.d2.c1.s2.e2
      action:
        type: replace
        target: trk.d2.c3
        guard: form.valid == true
```

## Notes
- The distinction between `card` and `state` is deliberate and enforced.
  `card` is a structural node in the spec — it has an ID, it has slots,
  it has triggers. `state` refers to runtime data values (e.g. the value
  of a field, the result of an API call). Do not use these terms
  interchangeably.
- A card is not a screen. A screen is a colloquial term. A card is
  a precisely addressed node with a mandatory ID.
- Transitions between cards within the same deck do not constitute
  navigation. Navigation is movement between decks. Card changes are
  condition changes — the route does not change, the appearance does.
- Every card transition triggered by an action must be declared in that
  card's `triggers` block. Undeclared transitions do not exist in MADL.
EOF

echo "  written: card.md"

# =============================================================================
# layer.md
# =============================================================================
cat > "$TARGET/layer.md" << 'EOF'
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
EOF

echo "  written: layer.md"

# =============================================================================
# slot.md
# =============================================================================
cat > "$TARGET/slot.md" << 'EOF'
# slot

## Definition
A named region within a card (or layer) that accepts and contains elements.
Slots divide a card's layout into addressable areas. Every element must belong
to exactly one slot. Slots have no visual representation of their own — they
are organisational containers for elements, not styled regions. The layout
relationship between slots (which is on top, which is on the left) is
determined by the implementation, not by MADL.

## WML Origin
New. WML had no sub-card layout regions — elements were placed directly inside
`<card>`. The `slot` is introduced because modern mobile layouts require a way
to address specific regions of a card without describing pixels or coordinates.
MADL uses slots to say "the element is in the footer area" without specifying
exactly where the footer is on screen.

## ID Pattern
```
Pattern:  {card}.s{n}
          {layer}.s{n}
Example:  trk.d2.c1.s2
          trk.l1.s1
```

## Declaration Format
```yaml
{slot_id}:
  name:     {description}          # optional but recommended
  elements:
    {element_id}: ...
```

## Example
```yaml
trk.d2.c1.s1:
  name: header
  elements:
    trk.d2.c1.s1.e1:
      type:  label
      label: Enter your data

trk.d2.c1.s2:
  name: body
  elements:
    trk.d2.c1.s2.e1:
      type:        field
      placeholder: Data value
    trk.d2.c1.s2.e2:
      type:  field
      placeholder: Notes

trk.d2.c1.s3:
  name: footer
  elements:
    trk.d2.c1.s3.e1:
      type:  control
      label: Save
    trk.d2.c1.s3.e2:
      type:  control
      label: Cancel
```

## Recommended Slot Names

These names are conventional and should be used consistently when the layout
follows standard mobile patterns. Custom names are permitted.

| Name       | Typical position and role                      |
|------------|------------------------------------------------|
| `header`   | Top of card. Title, back button, primary label.|
| `body`     | Main scrollable content area.                  |
| `footer`   | Bottom of card. Primary and secondary actions. |
| `sidebar`  | Side panel (iPad / large screen).              |
| `overlay`  | Reserved for overlay elements (use `o{n}` ID). |

## Notes
- A card MUST have at least one slot if it contains any elements.
- A slot MUST contain at least one element to be declared.
  Empty slots should not appear in the specification.
- Slots within a card have their own `{n}` sequence starting at 1.
  `trk.d2.c1.s1` and `trk.d2.c2.s1` are slots in different cards —
  the `s1` in each refers to the first slot of its respective card.
- Slots do not describe position, size, or visual styling.
  They describe containment only. The implementation decides layout.
- When communicating with an AI coding agent, reference the slot ID
  to specify where a new element should be placed:
  "Add a loading indicator to `trk.d2.c3.s1`" is unambiguous.
  "Add a loading indicator to the top of the saving screen" is not.
- Layers use the same slot pattern: `{app}.l{n}.s{n}`.
EOF

echo "  written: slot.md"

# =============================================================================
# done
# =============================================================================
echo ""
echo "  STRUCTURE basket populated. Files written:"
echo ""
ls -1 "$TARGET"/*.md | while read f; do
  size=$(wc -l < "$f")
  echo "    $(basename $f)  ($size lines)"
done
echo ""
echo "  Next: run populate_navigation.sh"
echo ""
