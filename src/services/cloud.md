# cloud

## Definition
A remote platform service providing infrastructure-level capabilities
to the application — authentication, file storage, push notifications,
analytics, crash reporting, feature flags, or any capability delivered
as a managed service rather than the application's own backend API.
Cloud services are distinct from the application's primary `api` service
in that they are operated by third parties and accessed via their own
SDKs or APIs rather than the application's own server.

## WML Origin
New. Cloud platform services did not exist in the WAP era. MADL
introduces `cloud` as a distinct service type because modern mobile
applications routinely depend on Firebase, Supabase, AWS Amplify,
or similar platforms, and those dependencies must be specified
alongside the application's own backend.

## ID Pattern
```
Pattern:  {app}.svc.cloud.{name}
Example:  trk.svc.cloud.auth
          trk.svc.cloud.storage
          trk.svc.cloud.push
          trk.svc.cloud.analytics
```

### Rules for {name}
- Lowercase alphanumeric, hyphens permitted
- Descriptive of the capability, not the vendor:
  `auth` not `firebase_auth`
  `storage` not `s3`
  `push` not `fcm`
- Vendor independence keeps the spec valid if the provider changes

## Cloud capability vocabulary

| name          | Description                                              |
|---------------|----------------------------------------------------------|
| `auth`        | User authentication and session management               |
| `storage`     | Remote file storage — images, documents, assets          |
| `push`        | Push notification delivery to devices                    |
| `analytics`   | Usage tracking and event reporting                       |
| `crashes`     | Crash reporting and diagnostics                          |
| `flags`       | Feature flags and remote configuration                   |
| `sync`        | Real-time data synchronisation                           |
| `functions`   | Serverless function invocation                           |

## Declaration Format
```yaml
{app}.svc.cloud.{name}:
  type:      cloud
  protocol:  SDK | REST | GraphQL
  provider:  {vendor name}          # optional — documents the current provider
  base-url:  {url}                  # for REST/GraphQL cloud services
  endpoints:
    {endpoint_id}: ...
  events:
    {event_id}: ...
```

## Example
```yaml
trk.svc.cloud.auth:
  type:     cloud
  protocol: SDK
  provider: Supabase
  endpoints:
    trk.svc.cloud.auth.ep.signin:
      method:   POST
      path:     /auth/signin
      input:
        - trk.d10.c1.s1.e1        # email field
        - trk.d10.c1.s1.e2        # password field
      output:   trk.d1.c1         # on success → home deck
      on-error: trk.d10.c2        # on failure → auth error card
    trk.svc.cloud.auth.ep.signout:
      method:   POST
      path:     /auth/signout
      output:   trk.d10.c1        # → login card
  events:
    trk.svc.cloud.auth.evt.session_expired:
      source:  trk.svc.cloud.auth
      trigger: trk.d1.c1.t8
      payload: session expiry notification

trk.svc.cloud.storage:
  type:     cloud
  protocol: SDK
  provider: Supabase
  endpoints:
    trk.svc.cloud.storage.ep.upload_avatar:
      method:   POST
      path:     /storage/avatars
      input:
        - trk.d8.c2.s1.e1        # avatar media element
      output:   trk.d8.c1        # → profile view card
      on-error: trk.d8.c3        # → upload error card

trk.svc.cloud.push:
  type:     cloud
  protocol: SDK
  provider: FCM
  events:
    trk.svc.cloud.push.evt.new_message:
      source:  trk.svc.cloud.push
      trigger: trk.d1.c1.t9
      payload: message content and sender

trk.svc.cloud.analytics:
  type:     cloud
  protocol: SDK
  provider: Mixpanel
```

## Notes
- `provider:` is optional but recommended. It documents which vendor
  currently implements the capability. If the vendor changes,
  the spec's endpoint and event declarations remain valid —
  only the `provider:` line changes.
- Cloud auth services typically manage session state outside the
  application's own store. The `user.authenticated` guard condition
  used throughout the interaction basket resolves against the auth
  service's session state.
- A cloud analytics service typically has no endpoints or events
  that affect the UI. It receives events passively. Declaring it
  in the spec makes the dependency visible even if it has no
  `bound-to` references.
- Cloud services with `SUBSCRIBE` endpoints (real-time sync via
  WebSocket or Server-Sent Events) produce a continuous stream
  of events. Declare these as `evt.{name}` nodes on the service
  and connect them to triggers on the relevant cards.
- Platform mappings vary entirely by provider. MADL specifies
  the capability and the operation — the implementation chooses
  the SDK and the specific API calls.
