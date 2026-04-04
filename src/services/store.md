# store

## Definition
The local persistent data layer of the application. A store holds data
on the device — in a database, in key-value preferences, in the secure
keychain, or in the file system. Unlike a `service`, a store is always
available regardless of network connectivity. Stores are the source
for offline data, cached data, user preferences, and any data that
must survive app restart. Elements bind to stores to display persisted
data; actions write to stores to persist new data.

## WML Origin
New. WML had no local storage concept — WAP devices had minimal storage
and data was fetched fresh on every request. MADL introduces `store`
because modern mobile applications are expected to work offline,
persist user data locally, and synchronise with remote services
when connectivity is restored.

## ID Pattern
```
Pattern:  {app}.store.{name}
Example:  trk.store.db
          trk.store.prefs
          trk.store.keychain
```

### Rules for {name}
- Lowercase alphanumeric, hyphens permitted
- Descriptive of the store's role or technology
- `db` for the primary relational or document database
- `prefs` for user preferences and settings
- `keychain` for sensitive credentials and tokens
- `cache` for temporary data that can be cleared

## Store type vocabulary

| store-type  | Description                                              |
|-------------|----------------------------------------------------------|
| `database`  | Structured relational or document store (SQLite, Realm, CoreData) |
| `keyvalue`  | Simple key-value preferences store                       |
| `keychain`  | Secure encrypted credential store                        |
| `filesystem`| File-based storage for documents, images, downloads      |
| `cache`     | Temporary store — may be cleared by the OS               |

## Declaration Format
```yaml
{app}.store.{name}:
  type:       store
  store-type: database | keyvalue | keychain | filesystem | cache
  protocol:   native | sqlite | realm | coredata | mmkv | asyncstorage
  endpoints:
    {endpoint_id}: ...
  events:
    {event_id}: ...
```

## Example
```yaml
trk.store.db:
  type:       store
  store-type: database
  protocol:   sqlite
  endpoints:
    trk.store.db.ep.items:
      method: GET
      path:   /items
    trk.store.db.ep.entries:
      method: GET
      path:   /entries
    trk.store.db.ep.save:
      method:   POST
      path:     /entries
      on-error: trk.d2.c4
    trk.store.db.ep.history_1:
      method: GET
      path:   /entries?offset=0&limit=1
    trk.store.db.ep.history_2:
      method: GET
      path:   /entries?offset=1&limit=1

trk.store.prefs:
  type:       store
  store-type: keyvalue
  protocol:   native
  endpoints:
    trk.store.prefs.ep.default_item:
      method: GET
      path:   /default_item
    trk.store.prefs.ep.set_default:
      method: POST
      path:   /default_item

trk.store.keychain:
  type:       store
  store-type: keychain
  protocol:   native
  endpoints:
    trk.store.keychain.ep.token:
      method: GET
      path:   /auth_token
    trk.store.keychain.ep.save_token:
      method: POST
      path:   /auth_token
```

## Notes
- Stores use `{app}.store.{name}` rather than `{app}.svc.{name}`
  because they are on-device and synchronous. The distinction matters
  to AI coding agents: a store endpoint does not require async/await
  in the same way a network service does (though some store
  implementations are async — that is an implementation concern).
- Store endpoints follow the same declaration pattern as service
  endpoints, using `GET` for reads and `POST` for writes. The `path`
  on a store endpoint is a logical path, not a URL — it identifies
  the data entity and query pattern.
- Elements bind to store paths the same way they bind to service
  endpoints: `bound-to: trk.store.db.ep.history_1`. The element
  does not need to know whether its data comes from a local store
  or a remote service — the binding is the same.
- Stores may emit events when their data changes — for example, when
  a background sync updates a local cache. Declare these as
  `{store}.evt.{name}` using the same event pattern as service events.
- Platform mappings:
  database → SQLite (cross-platform), Core Data (iOS), Room (Android),
             Realm (cross-platform)
  keyvalue → NSUserDefaults (iOS), SharedPreferences (Android),
             AsyncStorage (React Native)
  keychain → Keychain Services (iOS), Keystore (Android)
  filesystem → FileManager (iOS), File (Android)
