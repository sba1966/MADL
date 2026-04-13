# MADL_AGENT_INSTRUCTIONS_v0.3

## WHAT CHANGED FROM v0.2

All changes from v0.2 to v0.3 are non-breaking clarifications and extensions.
No existing valid v0.2 spec becomes invalid under v0.3.

```
Added in v0.3:
- input-type property for field elements
- scroll property for list elements
- overlay_id support for sheet-up/sheet-down transition targets
- Extended standard card name vocabulary (adding, deleting, confirming)
- Runtime form state vocabulary documented
- columns property for list elements
- item-triggers support for list elements
```

## WHAT CHANGED FROM v0.1 (v0.2 breaking change)

Single breaking change from v0.1 to v0.2. All other rules carry forward unchanged.

```
RULE_03  v0.1: IDs are lowercase, alphanumeric segments separated by dots.
               No spaces. No special chars.
         v0.2: IDs are lowercase, readable slugs separated by dots.
               Each segment is a meaningful word or short phrase.
               Hyphens permitted within a segment. No spaces. No other special chars.
               No length limit. No numeric shorthand.
```

All numeric shorthand ID patterns from v0.1 (`d{n}`, `c{n}`, `s{n}`, `e{n}`,
`l{n}`, `o{n}`, `t{n}`, `stk{n}`, `tab{n}`, `drw{n}`) are deprecated.
Any spec written using v0.1 ID patterns is a v0.1 spec and must be migrated
before it is considered a valid v0.2 spec.

---

## ROLE_CONTEXT

You are working within a project that uses MADL (Mobile Application Description
Language) as its single source of truth for application structure, navigation,
interaction, elements, and services. MADL is the authoritative specification
layer above all code. When MADL and code conflict, MADL is correct and code
must be updated. Never infer structure from code if a MADL spec exists.

---

## CRITICAL_RULES

These rules override all other reasoning. Violating any of them is a spec error.

```
RULE_01  Every node in the application MUST have a MADL ID before it is referenced anywhere.
RULE_02  IDs are cascading dot-separated paths. They encode full hierarchy. Never shorten or alias.
RULE_03  IDs are lowercase readable slugs separated by dots. Each segment is a meaningful name,
         unique among its siblings. Hyphens permitted within a segment. No numeric shorthand.
RULE_04  IDs are permanent. Once assigned, never change. Never reuse a retired ID.
         When an element is removed, retire its ID. Mint a new ID for its replacement.
RULE_05  Closed enumerations are closed. Never add a value without a spec change.
RULE_06  Structure (what exists) is described separately from Behaviour (what happens).
RULE_07  "card" is a structural spec node. "state" refers to runtime data values only.
RULE_08  "overlay" is a structural term. "modal" is a boolean property on an overlay.
RULE_09  Screenshots are not specifications. Ignore screenshot references in specs.
RULE_10  If an ID does not exist in the MADL spec, the thing it refers to does not exist.
```

---

## TAXONOMY

MADL has exactly five baskets. Every concept belongs to exactly one basket.

```
BASKET_1  STRUCTURE    — what exists and how it is addressed
BASKET_2  NAVIGATION   — how the user moves between structure nodes
BASKET_3  INTERACTION  — what the user does and what happens as a result
BASKET_4  ELEMENTS     — what populates the structure
BASKET_5  SERVICES     — what the application communicates with externally
```

---

## BASKET_1: STRUCTURE

### Node types

```
NODE       TERM     DEFINITION
root       app      Single root container. One per product. All IDs derive from this.
level_1    deck     Full-viewport destination. Only one deck visible at any time.
level_2    card     One named configuration of a deck. Same route, different appearance.
level_1    layer    Persistent chrome rendered across multiple decks. Not a deck.
level_3    slot     Named region within a card. Accepts elements. Divides layout.
```

### ID patterns

```
TERM     PATTERN                          EXAMPLE
app      {app_slug}                       tracker
deck     {app}.{deck_name}                tracker.onboarding
card     {deck}.{card_name}               tracker.onboarding.welcome
layer    {app}.{layer_name}               tracker.nav-bar
slot     {card}.{slot_name}               tracker.onboarding.welcome.header
```

### ID construction rules

```
{app_slug}     Readable slug. Unique per product. Chosen at project start. Never changed.
               Use the full or natural short form of the product name.
               Examples: tracker, finance-manager, daily-log, health-monitor

{deck_name}    Readable slug describing the deck's purpose or content.
               Examples: onboarding, home, item-detail, settings

{card_name}    One of the standard card name vocabulary, or a custom name if none applies.
               Examples: default, empty, loading, editing, error

{slot_name}    Readable slug describing the slot's layout region or purpose.
               Examples: header, content, footer, form, actions

{element_name} Readable slug describing the element's role or content.
               Examples: save-button, email-field, avatar-image, items-list
```

### Mandatory deck properties

```
PROPERTY   REQUIREMENT   VALUE
entry      MUST          {card_id} — default card shown on first open
exit       SHOULD        {deck_id | card_id} — target on back/cancel/complete
```

### Standard card name vocabulary

These are recommended names for card nodes. Use consistently.

```
NAME       CONDITION
default    Normal loaded state. Use when no other name applies.
empty      No data to display. First-use or post-clear state.
loading    Async operation in progress. Data not yet available.
loaded     Data present and rendered. Primary content state.
error      A failure occurred. Network, validation, or server.
adding     User is filling in a form to create a new record.
editing    User is actively modifying existing data.
saving     Write operation in flight. Awaiting confirmation.
deleting   Delete operation in flight. Awaiting confirmation or completion.
confirming User presented with a destructive or irreversible action requiring explicit acknowledgement.
success    Operation completed successfully.
```

### Inference rule for card naming

When reading a spec, apply the standard name vocabulary before creating custom names:
- "user creates a new record" → `adding`
- "user fills in the form" (existing record) → `editing`
- "user confirms deletion" → `confirming`
- "delete in progress" → `deleting`
- "save in progress" → `saving`
- "after successful save" → `success`
- "no data available" → `empty`
- "data loading" → `loading`
- "data displayed" → `loaded`
- "operation failed" → `error`

---

## BASKET_2: NAVIGATION

### Node types

```
TERM      DEFINITION
atlas     Complete map of all decks, cards, and permitted transitions. One per app.
stack     Navigator: decks pushed onto a back-enabled history stack.
tabset    Navigator: N decks presented as parallel persistent destinations.
drawer    Navigator: deck set hidden off-screen, revealed by gesture or trigger.
flow      Named linear sequence of decks with declared entry and exit.
entry     The default card shown when a deck is first opened.
exit      The card or deck reached when user navigates back/cancel/complete.
```

### ID patterns

```
TERM      PATTERN                          EXAMPLE
atlas     {app}.atlas                      tracker.atlas
stack     {app}.nav.{stack_name}           tracker.nav.main-stack
tabset    {app}.nav.{tabset_name}          tracker.nav.main-tabs
drawer    {app}.nav.{drawer_name}          tracker.nav.settings-drawer
flow      {app}.flow.{flow_name}           tracker.flow.onboarding
```

### Atlas declaration schema

```yaml
{app}.atlas:
  {deck_id}:
    entry: {card_id}
    exit:  {deck_id | card_id}
    nav:   {navigator_id}
```

### Navigation topology selection rules

```
CONDITION                                          USE
User drills into detail, can go back               stack
User switches between top-level destinations       tabset
User accesses secondary/settings destinations      drawer
User completes a linear multi-step task            flow
Overlay sequence required within a screen          modal-stack
```

### Horizontal vs vertical navigation

```
GESTURE        DIRECTION    TYPICAL TOPOLOGY
swipe-left     forward      stack push / tabset next
swipe-right    backward     stack pop / tabset prev
swipe-up       reveal up    sheet-up / drawer reveal
swipe-down     dismiss      sheet-down / modal-dismiss
tap            select       any transition type
```

---

## BASKET_3: INTERACTION

### Node types

```
TERM          DEFINITION
trigger       The gesture or system event that initiates an action.
action        The named operation that executes when a trigger fires.
transition    The movement from one card or deck to another.
guard         A condition that must evaluate true for transition to execute.
gesture       The physical trigger type. Closed enumeration — see below.
```

### ID patterns

```
TERM      PATTERN                              EXAMPLE
trigger   {card}.{trigger_name}               tracker.onboarding.welcome.tap-continue
action    {trigger}.action                    tracker.onboarding.welcome.tap-continue.action
```

### Gesture enumeration (closed — exhaustive)

```
tap             The primary single-finger tap.
long-press      Sustained press, typically 500ms+.
swipe-left      Horizontal swipe toward left edge.
swipe-right     Horizontal swipe toward right edge.
swipe-up        Vertical swipe toward top edge.
swipe-down      Vertical swipe toward bottom edge.
pinch           Two-finger pinch inward. Typically zoom-out or dismiss.
expand          Two-finger expand outward. Typically zoom-in.
scroll-end      User has reached the end of scrollable content.
back            Device or OS back action (hardware button or gesture).
system-event    Trigger fired by service event, not user gesture.
```

### Transition type enumeration (closed — exhaustive)

```
push            New deck slides in from right. Adds to stack.
pop             Current deck slides out to right. Removes from stack.
replace         Current deck replaced with no stack change.
modal-present   Deck or overlay slides up from bottom. Interrupts flow.
modal-dismiss   Modal slides down. Returns to underlying content.
sheet-up        Partial-height overlay slides up from bottom.
sheet-down      Sheet dismisses downward.
fade            Cross-fade between source and target.
none            Instant switch. No animation.
```

### Action declaration schema

```yaml
{trigger_id}:
  gesture:  {gesture_value}
  element:  {element_id}          # optional — binds trigger to specific element
  action:
    type:   {transition_type}
    target: {card_id | deck_id | overlay_id}
    guard:  {condition}           # optional boolean expression
    animation: {transition_type}  # optional override
```

### Guard expression format

```
Guards are boolean expressions. Supported operators:
  ==   equals
  !=   not equals
  >    greater than
  <    less than
  &&   logical AND
  ||   logical OR
  !    logical NOT

Examples:
  form.valid == true
  user.authenticated == true && session.active == true
  input.length > 0
```

### Runtime state vocabulary

These runtime form state identifiers are supported in guard expressions.
This is a closed enumeration — additional identifiers outside this set
are not permitted.

```
IDENTIFIER      DEFINITION
form.valid      true if all required fields pass validation
form.dirty      true if any field value differs from its bound-to value
form.pristine   true if no field values have changed (opposite of form.dirty)
```

---

## BASKET_4: ELEMENTS

### Node types

```
TERM      WML_ORIGIN     DEFINITION
element   generic        Any discrete UI component placed in a slot.
field     <input>        Element accepting user input.
label     <p>            Element displaying static or data-bound text.
control   new            Element that fires an action. Button, toggle, selector.
media     new            Element displaying image, video, or audio content.
list      new            Repeating element rendering a bound data collection.
overlay   new            Element rendered above the card surface. Always sub-typed.
```

### ID patterns

```
TERM      PATTERN                              EXAMPLE
element   {slot}.{element_name}               tracker.home.loaded.content.items-list
overlay   {card}.{overlay_name}               tracker.home.loaded.add-item-dialog
```

### Element type enumeration (closed — exhaustive)

```
field      control      label
media      list         overlay
```

### Overlay sub-type enumeration (closed — exhaustive)

```
dialog         Small centered modal. Confirmation, alert, short input.
               Always modal:true.

sheet          Slides up from bottom. Partial or full height.
               modal property must be explicitly declared.

toast          Non-modal notification. Auto-dismisses.
               Always modal:false. Requires auto-dismiss value in seconds.

tooltip        Contextual info bubble attached to specific element.
               Always modal:false.

action-sheet   List of options sliding up. Contextual choices.
               Always modal:true.
```

### Element declaration schema

```yaml
{element_id}:
  type:        {element_type}           # MANDATORY — no default
  label:       {string}                 # display text
  bound-to:    {endpoint_id | store_path}  # data source
  visible-if:  {boolean_condition}      # conditional render
  modal:       true | false             # overlays only
  auto-dismiss: {integer}               # toast only — seconds
  placeholder: {string}                # field only
  input-type:  text | number | decimal | email | phone | date | url  # field only
  scroll:      vertical | horizontal | both  # list only — default: vertical
```

### Property requirement matrix

```
PROPERTY       field   label   control   media   list   overlay
type           MUST    MUST    MUST      MUST    MUST   MUST
label          OPT     OPT     OPT       -       -      -
bound-to       OPT     OPT     -         OPT     MUST   -
visible-if     OPT     OPT     OPT       OPT     OPT    OPT
modal          -       -       -         -       -      MUST
auto-dismiss   -       -       -         -       -      toast only
placeholder    OPT     -       -         -       -      -
input-type     OPT     -       -         -       -      -
scroll         -       -       -         -       OPT    -
```

### Binding resolution rules

When `bound-to` references a store path:
```
bound-to: {app}.store.{name}.{field}
```

When `bound-to` references an endpoint:
```
bound-to: {app}.svc.{name}.ep.{name}
```

A `list` element's `bound-to` resolves to a collection endpoint or store table.
Each list item inherits the element schema of its parent list.

---

## BASKET_5: SERVICES

### Node types

```
TERM        DEFINITION
service     Any external system the application communicates with.
store       Local persistent data layer. On-device. Not a remote service.
endpoint    A named operation exposed by a service.
binding     Declared link between an element and a store or endpoint.
host        Device operating system capabilities.
cloud       Remote platform service. Auth, storage, push, analytics.
event       Async message arriving from a service. May trigger card change.
```

### ID patterns

```
TERM              PATTERN                              EXAMPLE
service           {app}.svc.{name}                    tracker.svc.api
store             {app}.store.{name}                  tracker.store.local
endpoint          {service}.ep.{name}                 tracker.svc.api.ep.save-entry
host capability   {app}.svc.host.{cap}                tracker.svc.host.gps
cloud service     {app}.svc.cloud.{name}              tracker.svc.cloud.auth
event             {service}.evt.{name}                tracker.svc.api.evt.save-complete
```

### Service declaration schema

```yaml
{app}.svc.{name}:
  type:      api | store | host | cloud
  protocol:  REST | GraphQL | WebSocket | native | SDK
  base-url:  {url}                        # api and cloud only
```

### Endpoint declaration schema

```yaml
{service}.ep.{name}:
  method:    GET | POST | PUT | DELETE | SUBSCRIBE
  path:      {path_template}
  input:     [{element_id}, ...]          # fields that provide input
  output:    {card_id | element_id}       # where response renders
  on-error:  {card_id}                   # error state target
```

### Event declaration schema

```yaml
{service}.evt.{name}:
  source:    {service_id}
  trigger:   {trigger_id}
  payload:   {description}
```

### Host capability enumeration (closed — exhaustive)

```
camera          gps             biometrics      notifications
contacts        accelerometer   microphone      nfc
bluetooth
```

---

## ID_HIERARCHY_COMPLETE_REFERENCE

The full canonical ID tree in derivation order:

```
{app}                                        root
{app}.{deck}                                 deck
{app}.{deck}.{card}                          card
{app}.{deck}.{card}.{slot}                   slot
{app}.{deck}.{card}.{slot}.{element}         element
{app}.{deck}.{card}.{trigger}                trigger
{app}.{deck}.{card}.{trigger}.action         action
{app}.{deck}.{card}.{overlay}                overlay
{app}.{layer}                                layer
{app}.atlas                                  atlas (singleton)
{app}.nav.{stack}                            stack navigator
{app}.nav.{tabset}                           tabset navigator
{app}.nav.{drawer}                           drawer navigator
{app}.flow.{flow}                            named flow
{app}.svc.{name}                             service
{app}.svc.host.{cap}                         host capability
{app}.svc.cloud.{name}                       cloud service
{app}.store.{name}                           local store
{app}.svc.{name}.ep.{name}                  endpoint
{app}.svc.{name}.evt.{name}                 event
```

All segments in `{}` are readable slugs chosen by the spec author.
No segment is a number. No segment is a type-prefix plus integer.

---

## PARSING_RULES

When you receive a natural language description of an application, apply these
rules to produce MADL output:

```
PARSE_01  Identify all full-viewport destinations → assign as deck nodes.
PARSE_02  Identify all named conditions of each deck → assign as card nodes.
PARSE_03  Identify persistent UI elements across decks → assign as layer nodes.
PARSE_04  Identify all user gestures → classify against gesture enumeration.
PARSE_05  Identify all "what happens next" descriptions → assign as action + transition.
PARSE_06  Identify all conditions gating navigation → assign as guard expressions.
PARSE_07  Identify all input fields, buttons, displays → assign element types.
PARSE_08  Identify all external data sources → assign as service, store, host, or cloud.
PARSE_09  Identify all async callbacks → assign as event nodes.
PARSE_10  Assign IDs in tree order: app → deck → card → slot → element.
PARSE_11  When a description is ambiguous, use standard card name vocabulary to resolve.
PARSE_12  When a description mentions "history", interpret as stack navigation.
PARSE_13  When a description mentions "tabs", interpret as tabset navigation.
PARSE_14  When a description mentions "settings" or "menu", interpret as drawer navigation.
PARSE_15  When a description mentions "popup", "dialog", "confirm" → overlay type: dialog.
PARSE_16  When a description mentions "swipe between", interpret as tabset or stack with swipe gesture.
PARSE_17  Choose ID segments that describe what the thing IS, not what it looks like.
          "item-list" not "big-scrollable-area". "save-button" not "blue-button".
PARSE_18  When two siblings would have the same readable name, disambiguate with
          a qualifying word. "primary-save-button" and "secondary-save-button",
          not "save-button-1" and "save-button-2".
```

---

## OUTPUT_FORMAT

When producing MADL specifications, use this structure:

```yaml
# MADL specification
# app: {app_id}
# version: {version}
# date: {date}

{app_id}:
  name: {human readable product name}

  atlas:
    {deck_id}:
      entry: {card_id}
      exit:  {deck_id | card_id}
      nav:   {navigator_id}

  navigators:
    {navigator_id}:
      type: stack | tabset | drawer

  layers:
    {layer_id}:
      label: {description}
      slots: [{slot_ids}]

  decks:
    {deck_id}:
      name: {description}
      cards:
        {card_id}:
          name: {standard_card_name}
          slots:
            {slot_id}:
              elements:
                {element_id}:
                  type: {element_type}
                  label: {string}
                  bound-to: {binding}
          triggers:
            {trigger_id}:
              gesture: {gesture_value}
              element: {element_id}
              action:
                type: {transition_type}
                target: {card_id | deck_id}
                guard: {condition}
          overlays:
            {overlay_id}:
              type: {overlay_subtype}
              modal: true | false

  services:
    {service_id}:
      type: api | store | host | cloud
      protocol: {protocol}
      endpoints:
        {endpoint_id}:
          method: {method}
          path: {path}
          on-error: {card_id}
      events:
        {event_id}:
          trigger: {trigger_id}
```

---

## VALIDATION_CHECKLIST

Before finalising any MADL output, verify:

```
CHECK_01  Every deck has an entry card declared in atlas.
CHECK_02  Every transition target exists as a declared deck, card, or overlay ID.
CHECK_03  Every bound-to reference resolves to a declared endpoint or store.
CHECK_04  Every gesture value is in the closed gesture enumeration.
CHECK_05  Every transition type is in the closed transition enumeration.
CHECK_06  Every overlay has a declared sub-type and modal value.
CHECK_07  Every toast overlay has an auto-dismiss value.
CHECK_08  Every element has a type declared.
CHECK_09  Every list element has a bound-to declared.
CHECK_10  No ID appears more than once in the specification.
CHECK_11  No ID contains uppercase letters, spaces, or special characters except hyphens.
CHECK_12  No ID segment is a number or a type-prefix plus integer (d1, c2, s3, e4 etc.).
CHECK_13  All ID segments within a parent scope are unique readable slugs.
CHECK_14  Every field with input-type declares a value from the closed input-type enumeration.
CHECK_15  Every list with scroll declares a value from the closed scroll enumeration.
CHECK_16  Every sheet-up transition target MUST reference a declared overlay of sub-type sheet.
CHECK_17  Every sheet-down transition target MUST reference the declared sheet overlay being dismissed.
```

---

## CONFLICT_RESOLUTION

```
CONFLICT                                    RESOLUTION
MADL spec vs code                           MADL is correct. Update code.
MADL spec vs screenshot                     MADL is correct. Screenshots are not specs.
MADL spec vs human description              Clarify with human. Do not guess.
Two valid MADL IDs for same thing           Flag as duplicate. Request resolution.
Gesture not in enumeration                  Use system-event. Flag for spec extension.
Transition not in enumeration               Use closest existing type. Flag for spec extension.
Card condition not in standard names        Create custom name. Document in spec comments.
Element removed and replaced                Retire old ID. Mint new ID. Log in CHANGELOG.
v0.1 numeric ID found in a v0.2 spec       Flag as migration error. Replace with readable slug.
```

---

## EXAMPLE_END_TO_END

Natural language input:
> "The app opens. If the user has a default item set, go straight to the data
> entry screen. Otherwise show a selection screen where they pick or add an
> item. On the data entry screen they fill a form and tap Save. If valid, save
> to the database and show the most recent history entry. History shows the
> last 5 entries as swipeable screens."

MADL output:

```yaml
# MADL specification
# app: tracker
# version: 0.2.0
# date: 2026-04-07

tracker:
  name: Tracker

  atlas:
    tracker.item-selection:
      entry: tracker.item-selection.default
      exit:  tracker.item-selection.default
      nav:   tracker.nav.main-stack
    tracker.data-entry:
      entry: tracker.data-entry.default
      exit:  tracker.item-selection.default
      nav:   tracker.nav.main-stack
    tracker.history-1:
      entry: tracker.history-1.loaded
      exit:  tracker.data-entry.default
      nav:   tracker.nav.history-tabs
    tracker.history-2:
      entry: tracker.history-2.loaded
      exit:  tracker.data-entry.default
      nav:   tracker.nav.history-tabs
    tracker.history-3:
      entry: tracker.history-3.loaded
      nav:   tracker.nav.history-tabs
    tracker.history-4:
      entry: tracker.history-4.loaded
      nav:   tracker.nav.history-tabs
    tracker.history-5:
      entry: tracker.history-5.loaded
      nav:   tracker.nav.history-tabs

  navigators:
    tracker.nav.main-stack:
      type: stack
    tracker.nav.history-tabs:
      type: tabset

  decks:

    tracker.item-selection:
      name: Item Selection
      cards:
        tracker.item-selection.default:
          name: default
          triggers:
            tracker.item-selection.default.auto-select:
              gesture: system-event
              guard: user.default_item != null
              action:
                type: replace
                target: tracker.data-entry.default
            tracker.item-selection.default.tap-item:
              gesture: tap
              element: tracker.item-selection.default.content.items-list
              action:
                type: push
                target: tracker.data-entry.default
          slots:
            tracker.item-selection.default.content:
              elements:
                tracker.item-selection.default.content.items-list:
                  type: list
                  bound-to: tracker.store.local.ep.items
                tracker.item-selection.default.content.add-item-button:
                  type: control
                  label: Add Item

    tracker.data-entry:
      name: Data Entry
      cards:
        tracker.data-entry.default:
          name: default
        tracker.data-entry.editing:
          name: editing
          triggers:
            tracker.data-entry.editing.tap-save-valid:
              gesture: tap
              element: tracker.data-entry.editing.actions.save-button
              action:
                type: replace
                target: tracker.data-entry.saving
                guard: form.valid == true
            tracker.data-entry.editing.tap-save-invalid:
              gesture: tap
              element: tracker.data-entry.editing.actions.save-button
              action:
                type: replace
                target: tracker.data-entry.error
                guard: form.valid == false
          slots:
            tracker.data-entry.editing.form:
              elements:
                tracker.data-entry.editing.form.data-field:
                  type: field
                  placeholder: Enter data
            tracker.data-entry.editing.actions:
              elements:
                tracker.data-entry.editing.actions.save-button:
                  type: control
                  label: Save
        tracker.data-entry.saving:
          name: saving
          triggers:
            tracker.data-entry.saving.on-save-complete:
              gesture: system-event
              action:
                type: replace
                target: tracker.history-1.loaded
        tracker.data-entry.error:
          name: error

    tracker.history-1:
      name: History — Latest
      cards:
        tracker.history-1.loaded:
          name: loaded
          slots:
            tracker.history-1.loaded.content:
              elements:
                tracker.history-1.loaded.content.entry-label:
                  type: label
                  bound-to: tracker.store.local.ep.history-latest
        tracker.history-1.empty:
          name: empty

    tracker.history-2:
      name: History — 2nd
      cards:
        tracker.history-2.loaded:
          name: loaded
          slots:
            tracker.history-2.loaded.content:
              elements:
                tracker.history-2.loaded.content.entry-label:
                  type: label
                  bound-to: tracker.store.local.ep.history-2nd
        tracker.history-2.empty:
          name: empty

    tracker.history-3:
      name: History — 3rd
      cards:
        tracker.history-3.loaded:
          name: loaded
        tracker.history-3.empty:
          name: empty

    tracker.history-4:
      name: History — 4th
      cards:
        tracker.history-4.loaded:
          name: loaded
        tracker.history-4.empty:
          name: empty

    tracker.history-5:
      name: History — 5th
      cards:
        tracker.history-5.loaded:
          name: loaded
        tracker.history-5.empty:
          name: empty

  services:
    tracker.store.local:
      type: store
      protocol: native
      endpoints:
        tracker.store.local.ep.save-entry:
          method: POST
          path: /entries
          on-error: tracker.data-entry.error
        tracker.store.local.ep.items:
          method: GET
          path: /items
        tracker.store.local.ep.history-latest:
          method: GET
          path: /entries?offset=0&limit=1
        tracker.store.local.ep.history-2nd:
          method: GET
          path: /entries?offset=1&limit=1
      events:
        tracker.store.local.evt.save-complete:
          trigger: tracker.data-entry.saving.on-save-complete
```

---

## META

```
language:             MADL
version:              0.3
intended_reader:      AI coding agent
human_readable:       true (by design — readable slug IDs)
source_of_truth:      MADL spec always supersedes code and screenshots
wml_terms_reused:     deck, card, entry, exit, action (from <do>), field (from <input>), label (from <p>)
total_terms:          34
closed_enumerations:  gesture_types, transition_types, overlay_subtypes, host_capabilities,
                      input_types, scroll_directions, form_state_identifiers
breaking_change:      RULE_03 — ID format. v0.1 numeric shorthand deprecated (v0.2).
                      No breaking changes in v0.3.
decided:              2026-04-13 via issues #4-#10 sba1966/MADL
```
