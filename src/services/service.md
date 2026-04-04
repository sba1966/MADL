# service

## Definition
Any external system the application communicates with. A service is
the abstract parent of all external communication — it may be a REST
API, a local database, a device OS capability, or a cloud platform.
Services are declared at the app level and referenced by elements
via `bound-to` and by events via their ID. The `service` term is
used when referring to the concept in general. In practice, every
service declaration specifies a concrete type: `api`, `store`,
`host`, or `cloud`.

## WML Origin
New. WML applications were largely self-contained — external data was
fetched by the WAP gateway before the deck was delivered to the device.
MADL makes services explicit because modern mobile applications
communicate directly with multiple external systems, and those
connections must be specified, not assumed.

## ID Pattern
```
Pattern:  {app}.svc.{name}
Example:  trk.svc.api
          trk.svc.host
          trk.svc.cloud
```

### Rules for {name}
- Lowercase alphanumeric, hyphens permitted
- Descriptive of the service's role, not its technology
- `api` for the primary backend REST/GraphQL service
- `host` for device OS capabilities (reserved name)
- `cloud` for remote platform services (reserved name)
- Custom names for named third-party services: `trk.svc.analytics`,
  `trk.svc.payments`, `trk.svc.maps`

## Service type enumeration (closed)

| Type    | Description                                              |
|---------|----------------------------------------------------------|
| `api`   | Remote HTTP service — REST, GraphQL, WebSocket           |
| `store` | Local on-device persistent storage                       |
| `host`  | Device operating system capabilities                     |
| `cloud` | Remote platform service — auth, storage, push, analytics |

## Declaration Format
```yaml
{app}.svc.{name}:
  type:     api | store | host | cloud
  protocol: REST | GraphQL | WebSocket | native | SDK
  base-url: {url}                    # api and cloud only
  endpoints:
    {endpoint_id}: ...
  events:
    {event_id}: ...
```

## Example
```yaml
trk.svc.api:
  type:     api
  protocol: REST
  base-url: https://api.tracker.example.com/v1

trk.store.db:
  type:     store
  protocol: native

trk.svc.host:
  type:     host
  protocol: native

trk.svc.cloud:
  type:     cloud
  protocol: SDK
  base-url: https://cloud.tracker.example.com
```

## Notes
- `trk.svc.host` uses the reserved name `host`. All device OS
  capabilities are children of this single service node, addressed
  as `trk.svc.host.{capability}`. There is only one host service
  per app — the device itself.
- Local stores use `{app}.store.{name}` rather than `{app}.svc.{name}`
  because stores are architecturally distinct from services — they are
  on-device, synchronous, and always available. See `store.md`.
- A service must be declared before any element can reference it
  via `bound-to`. An undeclared service reference is a specification
  error.
- Services do not have visual representations. They are structural
  nodes in the specification that answer: "what does this app
  talk to, and what can it ask for?"
- When an AI coding agent reads the services block, it can derive
  the complete external dependency graph of the application without
  reading implementation code.
