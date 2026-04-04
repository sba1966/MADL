# SERVICES

Everything the application communicates with outside its own structure.

**Bottom-right basket.** Below interaction — what fires when the user acts.

## Terms in this basket

| Term | ID Pattern | Definition |
|---|---|---|
| [service](./service.md) | `{app}.svc.{name}` | Any external system the app communicates with. |
| [store](./store.md) | `{app}.store.{name}` | Local persistent data layer. |
| [endpoint](./endpoint.md) | `{service}.ep.{name}` | Named operation on a service. |
| [binding](./binding.md) | declared on element | Link between element and data source. |
| [host](./host.md) | `{app}.svc.host.{cap}` | Device OS capabilities. |
| [cloud](./cloud.md) | `{app}.svc.cloud.{name}` | Remote platform service. |
| [event](./event.md) | `{service}.evt.{name}` | Async message from a service. |
