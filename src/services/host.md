# host

## Definition
The device operating system and its exposed capabilities. The host
is a special service that represents the physical device — its sensors,
its communication hardware, its security subsystems, and its platform
APIs. Host capabilities are addressed as `{app}.svc.host.{capability}`.
There is exactly one host service per application — the device itself.
The host cannot be replaced, mocked easily, or versioned the way a
remote service can.

## WML Origin
New. WAP devices exposed almost no hardware capabilities to WML
applications — there was no camera, no GPS, no biometrics. MADL
introduces `host` because modern mobile applications routinely
access device hardware, and those access points must be specified.

## ID Pattern
```
Pattern:  {app}.svc.host.{capability}
Example:  trk.svc.host.gps
          trk.svc.host.camera
          trk.svc.host.biometrics
```

## Host capability enumeration (closed — exhaustive)

| Capability      | Description                                              |
|-----------------|----------------------------------------------------------|
| `camera`        | Device camera — still image and video capture            |
| `gps`           | Location services — latitude, longitude, altitude        |
| `biometrics`    | Face ID, Touch ID, fingerprint authentication            |
| `notifications` | Push and local notification delivery and scheduling      |
| `contacts`      | Device address book — read and write                     |
| `accelerometer` | Motion sensing — device orientation and movement         |
| `microphone`    | Audio capture                                            |
| `nfc`           | Near Field Communication — read and write                |
| `bluetooth`     | Bluetooth LE and classic — discover, connect, communicate|

## Declaration Format
```yaml
{app}.svc.host:
  type:     host
  protocol: native
  capabilities:
    - {capability_name}
```

Individual capability endpoints do not need separate declaration —
they are addressed directly by their ID in `bound-to` and trigger
declarations.

## Example
```yaml
trk.svc.host:
  type:     host
  protocol: native
  capabilities:
    - gps
    - biometrics
    - notifications
```

Usage in element bindings:
```yaml
# Map element bound to GPS
trk.d3.c1.s1.e1:
  type:       media
  media-type: map
  bound-to:   trk.svc.host.gps
  alt:        Current location

# Camera capture trigger
trk.d8.c1.t1:
  gesture: tap
  element: trk.d8.c1.s1.e1      # camera button
  action:
    type:   none
    target: trk.d8.c1            # stays on card, camera overlay appears
```

Usage in service events:
```yaml
trk.svc.host.notifications.evt.received:
  source:  trk.svc.host.notifications
  trigger: trk.d1.c1.t5         # fires trigger on home deck
  payload: notification message and action
```

## Platform permission notes

Host capabilities require explicit user permission on both iOS and Android.
The spec should note which capabilities are required. Declaring a capability
in the host service block implies that the app requests permission at
the appropriate time. The permission request flow is an implementation
concern — MADL specifies that the capability is used, not when or how
permission is requested.

| Capability      | iOS permission                    | Android permission               |
|-----------------|-----------------------------------|----------------------------------|
| `camera`        | NSCameraUsageDescription          | CAMERA                           |
| `gps`           | NSLocationWhenInUseUsageDescription | ACCESS_FINE_LOCATION            |
| `biometrics`    | NSFaceIDUsageDescription          | USE_BIOMETRIC                    |
| `notifications` | UNUserNotificationCenter          | POST_NOTIFICATIONS               |
| `contacts`      | NSContactsUsageDescription        | READ_CONTACTS / WRITE_CONTACTS   |
| `accelerometer` | No permission required            | No permission required           |
| `microphone`    | NSMicrophoneUsageDescription      | RECORD_AUDIO                     |
| `nfc`           | NFCReaderUsageDescription         | NFC                              |
| `bluetooth`     | NSBluetoothAlwaysUsageDescription | BLUETOOTH_CONNECT                |

## Notes
- Declare only the capabilities the application actually uses.
  An AI coding agent reading the host declaration will generate
  permission request code for every listed capability. Undeclared
  capabilities will not have permission handling generated.
- `gps` capability provides a continuous stream of location data
  when bound to a `media` map element. For one-time location reads
  (e.g. tagging an entry with the current location), the binding
  is one-shot — fetch once, store with the entry.
- `biometrics` is used for authentication — confirming the user's
  identity before a sensitive action. It is not a data source for
  `bound-to`. It is invoked via a trigger action that calls
  `trk.svc.host.biometrics` as part of the authentication flow.
- `notifications` operates in two directions: outbound (the app
  schedules a notification) and inbound (a push notification
  arrives and may trigger a card change). Both directions are
  specified via events.
- The host capability enumeration is closed. If a required
  capability is not listed, open an issue with the platform
  API name and use case.
