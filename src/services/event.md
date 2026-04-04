# event

## Definition
An asynchronous message originating from a service or store that
may trigger a card change. Events are the mechanism by which
external systems communicate back to the application without the
user initiating an action. A push notification arriving, a sync
completing, a GPS location updating, a payment confirming — all
are events. Every event is declared on its source service and
connected to a trigger on a card via the `system-event` gesture.

## WML Origin
New. WML had no event model — applications were request/response
only, driven entirely by user navigation. MADL introduces events
because modern mobile applications are reactive: they must respond
to messages from the outside world without waiting for user input.

## ID Pattern
```
Pattern:  {service}.evt.{name}
          {store}.evt.{name}
Example:  trk.svc.api.evt.sync_complete
          trk.svc.cloud.push.evt.new_message
          trk.svc.host.notifications.evt.received
          trk.store.db.evt.data_changed
```

### Rules for {name}
- Lowercase alphanumeric, underscores permitted
- Descriptive of what happened, in past tense:
  `sync_complete`, `data_changed`, `session_expired`, `payment_confirmed`
- Not descriptive of what the app should do in response —
  that is the trigger's concern

## Declaration Format
```yaml
{service}.evt.{name}:
  source:   {service_id}              # MUST — which service emits this event
  trigger:  {card}.t{n}              # MUST — which trigger it fires
  payload:  {description}            # optional — what data arrives with event
```

## Example
```yaml
# Sync completion event → refresh history display
trk.svc.api.evt.sync_complete:
  source:  trk.svc.api
  trigger: trk.d3.c1.t1
  payload: updated entry count and latest entry data

# Push notification → show overlay on home deck
trk.svc.cloud.push.evt.new_message:
  source:  trk.svc.cloud.push
  trigger: trk.d1.c1.t9
  payload: message title, body, and action identifier

# Session expiry → force return to login
trk.svc.cloud.auth.evt.session_expired:
  source:  trk.svc.cloud.auth
  trigger: trk.d1.c1.t8
  payload: expiry reason

# Local database change → update bound list elements
trk.store.db.evt.data_changed:
  source:  trk.store.db
  trigger: trk.d1.c1.t7
  payload: changed entity type and ID

# GPS location update → refresh map
trk.svc.host.gps.evt.location_updated:
  source:  trk.svc.host.gps
  trigger: trk.d3.c1.t2
  payload: latitude, longitude, accuracy
```

The corresponding `system-event` triggers on their cards:

```yaml
# Trigger fired by sync completion
trk.d3.c1.t1:
  gesture: system-event
  action:
    type:   replace
    target: trk.d3.c1
    guard:  sync.entry_count > 0

# Trigger fired by session expiry
trk.d1.c1.t8:
  gesture: system-event
  action:
    type:   replace
    target: trk.d10.c1        # login deck

# Trigger fired by GPS update
trk.d3.c1.t2:
  gesture: system-event
  action:
    type:   none
    target: trk.d3.c1         # stays on card, map element re-renders
```

## Event lifecycle

```
1. Service emits event (network response, push, timer, sensor)
2. Event node connects event to trigger via trigger: {id}
3. Trigger fires with gesture: system-event
4. Guard evaluated — if false, event consumed silently
5. Action executes — transition, replace, or none
6. Target card/element renders with payload data
```

## Notes
- An event always connects to exactly one trigger. If the same
  event should affect multiple cards or elements, use one trigger
  per affected card — declare multiple event nodes with different
  names that reference the same source event type, each connected
  to a trigger on a different card.
- Events that carry no payload (fire-and-forget signals) still
  require a `payload:` description, even if it is "none". This
  makes the intent explicit.
- `action: type: none` is valid for events that update bound
  elements in place without navigating. The card stays the same;
  the bound elements re-render with fresh data from the service.
- Events are the only mechanism for background-initiated UI changes.
  Do not model background updates as user-initiated triggers —
  if the user did not do something to cause the change, it is an event.
- An event with no declared trigger has no effect on the UI.
  It is consumed silently. If an event should have no UI effect
  (e.g. a telemetry event), omit the `trigger:` field and
  add a comment explaining why.
- The order of event processing when multiple events arrive
  simultaneously is an implementation concern. MADL specifies
  what each event does, not the priority or sequencing of
  concurrent events.
