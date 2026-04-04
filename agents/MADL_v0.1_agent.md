# MADL_AGENT_INSTRUCTIONS_v0.1

## ROLE_CONTEXT

You are working within a project that uses MADL (Mobile Application Description Language) as its single source of truth for application structure, navigation, interaction, elements, and services. MADL is the authoritative specification layer above all code. When MADL and code conflict, MADL is correct and code must be updated. Never infer structure from code if a MADL spec exists.

---

## CRITICAL_RULES

These rules override all other reasoning. Violating any of them is a spec error.

```
RULE_01  Every node in the application MUST have a MADL ID before it is referenced anywhere.
RULE_02  IDs are cascading dot-separated paths. They encode full hierarchy. Never shorten or alias.
RULE_03  IDs are lowercase, alphanumeric segments separated by dots. No spaces. No special chars.
RULE_04  IDs are permanent. Once assigned, never change. Never reuse a retired ID.
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
TERM     PATTERN                    EXAMPLE
app      {app_id}                   trk
deck     {app}.d{n}                 trk.d2
card     {deck}.c{n}                trk.d2.c3
layer    {app}.l{n}                 trk.l1
slot     {card}.s{n}                trk.d2.c3.s2
```

### ID construction rules

```
{app_id}   2-6 character alphanumeric slug. Unique per product. Chosen at project start.
{n}        Positive integer. Assigned sequentially at node creation. Never reused.
```

### Mandatory deck properties

```
PROPERTY   REQUIREMENT   VALUE
entry      MUST          {card_id} — default card shown on first open
exit       SHOULD        {deck_id | card_id} — target on back/cancel/complete
```

### Standard card name vocabulary

These are recommended identifiers for the `c{n}` nodes. Use consistently.

```
NAME       CONDITION
default    Normal loaded state. Use when no other name applies.
empty      No data to display. First-use or post-clear state.
loading    Async operation in progress. Data not yet available.
loaded     Data present and rendered. Primary content state.
error      A failure occurred. Network, validation, or server.
editing    User is actively modifying existing data.
saving     Write operation in flight. Awaiting confirmation.
success    Operation completed successfully.
```

### Inference rule for card naming

When reading a spec, if a card is described as "the screen where the user fills in the form", map it to `editing`. If described as "the screen after successful save", map it to `success`. Apply the standard name vocabulary before creating custom names.

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
TERM      PATTERN                 EXAMPLE
atlas     {app}.atlas             trk.atlas
stack     {app}.nav.stk{n}        trk.nav.stk1
tabset    {app}.nav.tab{n}        trk.nav.tab1
drawer    {app}.nav.drw{n}        trk.nav.drw1
flow      {app}.flow.{name}       trk.flow.onboard
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
TERM      PATTERN            EXAMPLE
trigger   {card}.t{n}        trk.d2.c1.t1
action    {trigger}.a        trk.d2.c1.t1.a
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
    target: {card_id | deck_id}
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
TERM      PATTERN         EXAMPLE
element   {slot}.e{n}     trk.d2.c1.s2.e1
overlay   {card}.o{n}     trk.d2.c1.o1
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

A `list` element's `bound-to` resolves to a collection endpoint or store table. Each list item inherits the element schema of its parent list.

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
TERM              PATTERN                       EXAMPLE
service           {app}.svc.{name}              trk.svc.api
store             {app}.store.{name}            trk.store.db
endpoint          {service}.ep.{name}           trk.svc.api.ep.save
host capability   {app}.svc.host.{cap}          trk.svc.host.gps
cloud service     {app}.svc.cloud.{name}        trk.svc.cloud.auth
event             {service}.evt.{name}          trk.svc.api.evt.sync
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
  trigger:   {card_id}.t{n}              # which trigger it fires
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
{app}                                    root
{app}.d{n}                               deck
{app}.d{n}.c{n}                          card
{app}.d{n}.c{n}.s{n}                     slot
{app}.d{n}.c{n}.s{n}.e{n}               element
{app}.d{n}.c{n}.t{n}                     trigger
{app}.d{n}.c{n}.t{n}.a                   action
{app}.d{n}.c{n}.o{n}                     overlay
{app}.l{n}                               layer
{app}.atlas                              atlas (singleton)
{app}.nav.stk{n}                         stack navigator
{app}.nav.tab{n}                         tabset navigator
{app}.nav.drw{n}                         drawer navigator
{app}.flow.{name}                        named flow
{app}.svc.{name}                         service
{app}.svc.host.{cap}                     host capability
{app}.svc.cloud.{name}                   cloud service
{app}.store.{name}                       local store
{app}.svc.{name}.ep.{name}              endpoint
{app}.svc.{name}.evt.{name}             event
```

---

## PARSING_RULES

When you receive a natural language description of an application, apply these rules to produce MADL output:

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
  name: {human readable name}

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
CHECK_02  Every transition target exists as a declared deck or card ID.
CHECK_03  Every bound-to reference resolves to a declared endpoint or store.
CHECK_04  Every gesture value is in the closed gesture enumeration.
CHECK_05  Every transition type is in the closed transition enumeration.
CHECK_06  Every overlay has a declared sub-type and modal value.
CHECK_07  Every toast overlay has an auto-dismiss value.
CHECK_08  Every element has a type declared.
CHECK_09  Every list element has a bound-to declared.
CHECK_10  No ID appears more than once in the specification.
CHECK_11  No ID contains uppercase letters, spaces, or special characters.
CHECK_12  All {n} values within a parent scope are unique positive integers.
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
```

---

## EXAMPLE_END_TO_END

Natural language input:
> "The app opens. If the user has a default item set, go straight to the data entry screen.
> Otherwise show a selection screen where they pick or add an item.
> On the data entry screen they fill a form and tap Save.
> If valid, save to the database and show the most recent history entry.
> History shows the last 5 entries as swipeable screens."

MADL output:

```yaml
trk:
  name: Tracker

  atlas:
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

  navigators:
    trk.nav.stk1:
      type: stack
    trk.nav.tab1:
      type: tabset

  decks:

    trk.d1:
      name: Item Selection
      cards:
        trk.d1.c1:
          name: default
          triggers:
            trk.d1.c1.t1:
              gesture: system-event
              guard: user.default_item != null
              action:
                type: replace
                target: trk.d2.c1
            trk.d1.c1.t2:
              gesture: tap
              element: trk.d1.c1.s1.e1
              action:
                type: push
                target: trk.d2.c1
          slots:
            trk.d1.c1.s1:
              elements:
                trk.d1.c1.s1.e1:
                  type: list
                  bound-to: trk.store.db.ep.items
                trk.d1.c1.s1.e2:
                  type: control
                  label: Add Item

    trk.d2:
      name: Data Entry
      cards:
        trk.d2.c1:
          name: default
        trk.d2.c2:
          name: editing
          triggers:
            trk.d2.c2.t1:
              gesture: tap
              element: trk.d2.c2.s2.e1
              action:
                type: replace
                target: trk.d2.c3
                guard: form.valid == true
            trk.d2.c2.t2:
              gesture: tap
              element: trk.d2.c2.s2.e1
              action:
                type: replace
                target: trk.d2.c4
                guard: form.valid == false
          slots:
            trk.d2.c2.s1:
              elements:
                trk.d2.c2.s1.e1:
                  type: field
                  placeholder: Enter data
            trk.d2.c2.s2:
              elements:
                trk.d2.c2.s2.e1:
                  type: control
                  label: Save
        trk.d2.c3:
          name: saving
          triggers:
            trk.d2.c3.t1:
              gesture: system-event
              action:
                type: replace
                target: trk.d3.c1
        trk.d2.c4:
          name: error

    trk.d3:
      name: History -1 (latest)
      cards:
        trk.d3.c1:
          name: loaded
          slots:
            trk.d3.c1.s1:
              elements:
                trk.d3.c1.s1.e1:
                  type: label
                  bound-to: trk.store.db.ep.history_1
        trk.d3.c2:
          name: empty

    trk.d4:
      name: History -2
      cards:
        trk.d4.c1:
          name: loaded
          slots:
            trk.d4.c1.s1:
              elements:
                trk.d4.c1.s1.e1:
                  type: label
                  bound-to: trk.store.db.ep.history_2
        trk.d4.c2:
          name: empty

    trk.d5:
      name: History -3
      cards:
        trk.d5.c1:
          name: loaded
        trk.d5.c2:
          name: empty

    trk.d6:
      name: History -4
      cards:
        trk.d6.c1:
          name: loaded
        trk.d6.c2:
          name: empty

    trk.d7:
      name: History -5
      cards:
        trk.d7.c1:
          name: loaded
        trk.d7.c2:
          name: empty

  services:
    trk.store.db:
      type: store
      protocol: native
      endpoints:
        trk.store.db.ep.save:
          method: POST
          path: /entries
          on-error: trk.d2.c4
        trk.store.db.ep.items:
          method: GET
          path: /items
        trk.store.db.ep.history_1:
          method: GET
          path: /entries?offset=0&limit=1
        trk.store.db.ep.history_2:
          method: GET
          path: /entries?offset=1&limit=1
      events:
        trk.store.db.evt.save_complete:
          trigger: trk.d2.c3.t1
```

---

## META

```
language:   MADL
version:    0.1
intended_reader: AI coding agent
human_readable: false
source_of_truth: MADL spec always supersedes code and screenshots
wml_terms_reused: deck, card, entry, exit, action (from <do>), field (from <input>), label (from <p>)
total_terms: 34
closed_enumerations: gesture_types, transition_types, overlay_subtypes, host_capabilities
```
