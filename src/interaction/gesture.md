# gesture

## Definition
The physical or system-level trigger type that initiates a trigger.
Gesture is a closed enumeration — the complete set of valid gesture
values is defined here and may not be extended without a spec change.
A gesture value is declared on a trigger node and describes what the
user does (or what the system fires) to initiate that trigger.
Gesture and action are separate concerns: the gesture is the "what
the user does", the action is the "what the system does in response".

## WML Origin
New as an explicit enumeration. WML's `<do>` had a `type` attribute
with values like `accept`, `prev`, `help`, `delete` — these described
interaction roles, not physical gestures. MADL uses physical gesture
names because modern touch interfaces have a richer vocabulary
(swipe direction, pinch, long-press) that must be specified precisely,
and because the gesture is independent of the UI element it applies to.

## ID Pattern
Gestures do not have IDs. They are enumeration values on trigger nodes:
```yaml
{trigger_id}.gesture: {gesture_value}
```

## Gesture enumeration (closed — exhaustive)

| Value          | Description                                                    |
|----------------|----------------------------------------------------------------|
| `tap`          | Single finger, brief touch and release. The primary action gesture. |
| `long-press`   | Single finger sustained contact, typically 500ms or more. Reveals contextual options. |
| `swipe-left`   | Single finger horizontal movement toward the left edge. Forward navigation or delete reveal. |
| `swipe-right`  | Single finger horizontal movement toward the right edge. Back navigation or archive reveal. |
| `swipe-up`     | Single finger vertical movement toward the top edge. Reveal content below, dismiss a sheet. |
| `swipe-down`   | Single finger vertical movement toward the bottom edge. Dismiss a modal or sheet, pull-to-refresh. |
| `pinch`        | Two fingers moving toward each other. Zoom out or dismiss. |
| `expand`       | Two fingers moving away from each other. Zoom in or expand. |
| `scroll-end`   | The user has reached the end of a scrollable list or content area. Triggers pagination or load-more. |
| `back`         | Device or OS back action. Hardware back button (Android), back swipe gesture (iOS), or navigation bar back control. |
| `system-event` | Not a user gesture. Fires when a service event arrives, a timer completes, or an async operation resolves. |

## Usage examples

```yaml
# Primary tap on a control
trk.d2.c1.t1:
  gesture: tap
  element: trk.d2.c1.s3.e1

# Long press for contextual options
trk.d3.c1.t2:
  gesture: long-press
  element: trk.d3.c1.s1.e1

# Swipe between history decks
trk.d3.c1.t3:
  gesture: swipe-left
  action:
    type:   replace
    target: trk.d4

trk.d3.c1.t4:
  gesture: swipe-right
  action:
    type:   replace
    target: trk.d2

# Pull to refresh via swipe-down
trk.d3.c1.t5:
  gesture: swipe-down
  action:
    type:   replace
    target: trk.d3.c2      # loading card

# Load more on scroll end
trk.d1.c1.t6:
  gesture: scroll-end
  action:
    type:   replace
    target: trk.d1.c3      # loading-more card

# OS back gesture
trk.d2.c2.t7:
  gesture: back
  action:
    type:   pop
    target: trk.d1.c1

# System event — service callback
trk.d2.c3.t1:
  gesture: system-event
  action:
    type:   replace
    target: trk.d3.c1
    guard:  save.complete == true
```

## Platform notes

| Gesture       | iOS                        | Android                     |
|---------------|----------------------------|-----------------------------|
| `tap`         | UITapGestureRecognizer     | View.OnClickListener        |
| `long-press`  | UILongPressGestureRecognizer | View.OnLongClickListener  |
| `swipe-left`  | UISwipeGestureRecognizer   | GestureDetector onFling     |
| `swipe-right` | UISwipeGestureRecognizer   | GestureDetector onFling     |
| `swipe-up`    | UIPanGestureRecognizer     | GestureDetector onFling     |
| `swipe-down`  | UIPanGestureRecognizer     | GestureDetector onFling     |
| `pinch`       | UIPinchGestureRecognizer   | ScaleGestureDetector        |
| `expand`      | UIPinchGestureRecognizer   | ScaleGestureDetector        |
| `scroll-end`  | scrollViewDidScroll        | RecyclerView.OnScrollListener |
| `back`        | navigation controller pop  | onBackPressed / back gesture |
| `system-event`| NotificationCenter / async | LiveData / EventBus / coroutine |

## Notes
- The gesture enumeration is closed. If a required gesture is not in
  the list, use `system-event` as a temporary placeholder and open
  an issue proposing the addition with justification.
- `swipe-left` and `swipe-right` on tab sets typically switch between
  tabs. Declare them explicitly if this is intended — do not rely on
  the navigator's default swipe behaviour being spec-compliant.
- `back` on iOS is the swipe-right-from-left-edge gesture when in a
  stack navigator, not a physical button. On Android it is both the
  hardware back button and the OS back gesture. MADL uses `back` for
  both — the implementation handles platform differences.
- `system-event` is the only gesture that is not initiated by the user.
  It fires when a service event or async completion arrives. The
  connection between the event and the trigger is declared on the
  event node in the services basket.
- Two triggers on the same card with the same gesture and no element
  binding is a conflict. The specification must be corrected —
  either bind one to a specific element, or add guards that are
  mutually exclusive.
