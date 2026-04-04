# binding

## Definition
A declared link between an element and its data source — a store path
or a service endpoint. A binding specifies that an element's content
comes from, or is written to, a specific data location. Bindings make
the data flow of the application explicit in the specification:
any reader can trace from any element back to its data source, and
any AI agent can generate the correct data fetching and rendering
code without guessing.

## WML Origin
New. WML had no data binding — content was embedded directly in the
WML markup at the time the gateway assembled the deck. MADL introduces
binding as a first-class concept because the separation of UI structure
(what elements exist) from data flow (where their content comes from)
is essential for a specification that is independent of implementation.

## ID Pattern
Bindings do not have IDs. They are properties declared on elements:
```yaml
{element_id}.bound-to: {endpoint_id | store_path}
```

## Declaration Format
```yaml
{element_id}:
  type:     {element_type}
  bound-to: {app}.svc.{name}.ep.{name}      # service endpoint
            | {app}.store.{name}.ep.{name}   # store endpoint
            | {app}.svc.host.{capability}    # host capability
            | assets/{path}                  # static asset
```

## Binding direction

| Element type | Binding direction | Meaning                              |
|--------------|-------------------|--------------------------------------|
| `label`      | read              | Displays value from source           |
| `media`      | read              | Renders content from source          |
| `list`       | read              | Renders collection from source       |
| `field`      | read + write      | Pre-fills from source, saves back     |
| `control`    | —                 | Controls do not bind to data sources |
| `overlay`    | —                 | Overlays do not bind to data sources |

## Example
```yaml
# Label bound to a store endpoint — read only
trk.d3.c1.s1.e1:
  type:     label
  bound-to: trk.store.db.ep.history_1

# Field bound to a store path — read and write
trk.d2.c2.s1.e1:
  type:        field
  field-type:  text
  bound-to:    trk.store.db.ep.entries
  placeholder: Data value

# List bound to a remote service endpoint
trk.d1.c1.s1.e1:
  type:     list
  bound-to: trk.store.db.ep.items

# Media bound to host GPS capability
trk.d3.c1.s1.e1:
  type:       media
  media-type: map
  bound-to:   trk.svc.host.gps

# Media bound to a remote URL endpoint
trk.d8.c1.s1.e1:
  type:       media
  media-type: avatar
  bound-to:   trk.store.db.ep.user_avatar

# Field bound to preferences store
trk.d8.c2.s1.e1:
  type:        field
  field-type:  toggle
  label:       Notifications
  bound-to:    trk.store.prefs.ep.notifications
```

## Binding resolution rules

When an element declares `bound-to`, the implementation resolves the
binding at render time:

```
1. Card loads → all bound elements on the card initiate their bindings
2. For GET endpoints: fetch data → render element with response
3. For field elements: pre-fill with current value from source
4. When an action fires with fields in its input list:
   collect field values → submit to endpoint → render response
5. If endpoint returns error: transition to on-error card
```

## Notes
- A `field` binding is bidirectional by convention. The field reads
  its current value from the source on load (pre-fill) and writes
  its value back to the source when an action with that field in
  its `input` list fires. The write direction is triggered by the
  action, not by the field itself.
- `bound-to: trk.svc.host.gps` is a special case — the GPS host
  capability streams location data continuously. The bound element
  (typically a `media` map) updates in real time as location changes.
  Other host capabilities are typically one-time reads.
- An element without `bound-to` has static content (declared via
  the `label:` property) or no content (which would be invalid).
  Every `list` element MUST have `bound-to`. Every `media` element
  SHOULD have `bound-to` unless it references a static asset.
- When two elements on the same card bind to the same endpoint,
  both are updated when the endpoint responds. The endpoint is
  called once — the implementation fans out the response to all
  bound elements. MADL does not require duplicate endpoint calls.
- Binding to a static asset uses a file path relative to the
  project's asset directory: `bound-to: assets/images/hero.png`.
  Static asset bindings are read-only and require no network call.
