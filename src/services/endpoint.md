# endpoint

## Definition
A named operation exposed by a service or store. An endpoint is what
the application calls when it needs to read data, write data, or
invoke a remote operation. Endpoints are the atomic units of
communication — each endpoint does exactly one thing and has a
declared input, output, and error target. Elements bind to endpoints
to display data; actions invoke endpoints to write data; events fire
when endpoints complete asynchronously.

## WML Origin
New. WML communication was handled by the WAP gateway — the application
deck never declared its data sources explicitly. MADL makes endpoints
first-class specification nodes because the question "where does this
data come from?" is as important as "what does this card show?".

## ID Pattern
```
Pattern:  {service}.ep.{name}
          {store}.ep.{name}
Example:  trk.svc.api.ep.save
          trk.store.db.ep.history_1
```

### Rules for {name}
- Lowercase alphanumeric, hyphens and underscores permitted
- Descriptive of the operation: `save`, `load`, `search`, `delete`
- For collection endpoints, append the entity: `items`, `entries`
- For filtered or paginated variants, append the qualifier:
  `history_1`, `history_latest`, `search_results`

## Declaration Format
```yaml
{service}.ep.{name}:
  method:   GET | POST | PUT | DELETE | PATCH | SUBSCRIBE
  path:     {path_template}         # URL path for api/cloud, logical path for store
  input:    [{element_ids}]         # elements that provide input data
  output:   {card_id | element_id}  # where the response is rendered
  on-error: {card_id}              # error state target
```

## HTTP method semantics

| Method      | Operation                          | Typical use                  |
|-------------|-------------------------------------|------------------------------|
| `GET`       | Read — retrieve data               | Load list, fetch record      |
| `POST`      | Create — submit new data           | Save entry, create item      |
| `PUT`       | Replace — update entire record     | Full update                  |
| `PATCH`     | Modify — partial update            | Update specific fields       |
| `DELETE`    | Remove — delete record             | Delete item                  |
| `SUBSCRIBE` | Stream — receive ongoing updates   | Real-time sync, WebSocket    |

## Example
```yaml
# Read endpoint — returns a collection
trk.svc.api.ep.items:
  method:   GET
  path:     /items
  output:   trk.d1.c1.s1.e1      # the list element on deck 1 card 1

# Write endpoint — accepts form fields as input
trk.svc.api.ep.save:
  method:   POST
  path:     /entries
  input:
    - trk.d2.c2.s1.e1            # value field
    - trk.d2.c2.s1.e2            # notes field
    - trk.d2.c2.s1.e3            # date field
  output:   trk.d3.c1            # on success, deck 3 card 1 renders result
  on-error: trk.d2.c4            # on failure, show error card

# Paginated read endpoint
trk.store.db.ep.history_1:
  method: GET
  path:   /entries?offset=0&limit=1
  output: trk.d3.c1.s1.e1

# Parameterised path
trk.svc.api.ep.item_detail:
  method:   GET
  path:     /items/{item.id}
  output:   trk.d2.c1

# Streaming endpoint
trk.svc.api.ep.live_sync:
  method:   SUBSCRIBE
  path:     /sync/stream
  output:   trk.store.db          # response updates the local store
```

## Notes
- `input` lists the element IDs whose values are sent as the request
  body or query parameters. For `GET` requests, inputs become query
  parameters. For `POST`/`PUT`/`PATCH`, inputs become the request body.
- `output` declares where the response is rendered. It may be a card
  (the card transitions to show the response) or an element (the element
  re-renders with the response data). If the response updates a store,
  point `output` at the store ID — the store then propagates to
  any bound elements.
- `on-error` is the card that is shown when the endpoint returns an
  error (network failure, server error, validation rejection). Every
  endpoint that writes data MUST declare `on-error`. Read endpoints
  SHOULD declare `on-error`.
- Path templates use `{variable}` syntax for dynamic segments.
  The variable resolves from the current data context — `{item.id}`
  resolves from the selected item in the current card's context.
- `SUBSCRIBE` endpoints establish a persistent connection (WebSocket,
  Server-Sent Events). Their `output` typically points to a store
  that is updated continuously, which in turn updates any bound
  elements in real time.
- An endpoint is invoked when a trigger's action executes and
  the action's target involves data that requires the endpoint.
  The linkage is implicit: if a card's data source is `bound-to`
  an endpoint, that endpoint is called when the card loads.
  If an action's `input` lists field IDs, those fields' values
  are submitted to the endpoint when the action fires.
