# control

## Definition
An element that the user interacts with to trigger an action. Controls
are the interactive elements on a card that connect user intent to
the trigger/action system. A button, a toggle switch, a dropdown
selector, a radio group, a segmented control — all are controls.
The defining characteristic of a control is that interacting with
it fires a trigger declared on the parent card.

## WML Origin
New. WML used `<anchor>` for navigation links and `<do>` for action
bindings — there was no single term for an interactive UI element.
MADL introduces `control` as the term for any element whose primary
purpose is to initiate an action, distinguishing it from `field`
(which captures input) and `label` (which displays content).

## ID Pattern
```
Pattern:  {slot}.e{n}   with   type: control
Example:  trk.d2.c2.s3.e1
```

## Declaration Format
```yaml
{element_id}:
  type:          control
  control-type:  button | toggle | selector | segmented | stepper |
                 checkbox | radio | fab | icon-button    # default: button
  label:         {string}         # visible label — optional for icon-button
  icon:          {icon name}      # optional
  visible-if:    {condition}      # optional
  enabled-if:    {condition}      # optional — when false, rendered but inactive
```

## Control type vocabulary

| control-type | Description                                              |
|--------------|----------------------------------------------------------|
| `button`     | Standard tap target with text label (default)            |
| `toggle`     | Binary on/off switch — like a field toggle but fires an action |
| `selector`   | Dropdown or picker that fires an action on selection     |
| `segmented`  | Horizontal set of mutually exclusive options             |
| `stepper`    | Increment/decrement control for a numeric value          |
| `checkbox`   | Binary checked state that fires an action on change      |
| `radio`      | Single selection from a small visible set                |
| `fab`        | Floating action button — primary screen action           |
| `icon-button`| Tap target represented by an icon only, no text label    |

## Example
```yaml
# Primary action button
trk.d2.c2.s3.e1:
  type:         control
  control-type: button
  label:        Save

# Secondary action button
trk.d2.c2.s3.e2:
  type:         control
  control-type: button
  label:        Cancel

# FAB for primary deck action
trk.d1.c1.s1.e1:
  type:         control
  control-type: fab
  icon:         plus
  label:        Add Entry

# Toggle that fires an action
trk.d2.c2.s2.e3:
  type:         control
  control-type: toggle
  label:        Advanced mode

# Segmented selector
trk.d2.c2.s1.e1:
  type:         control
  control-type: segmented
  label:        View

# Icon button on a layer
trk.l1.s1.e3:
  type:         control
  control-type: icon-button
  icon:         menu

# Conditionally enabled button
trk.d2.c2.s3.e1:
  type:         control
  control-type: button
  label:        Save
  enabled-if:   form.valid == true
```

## Connecting controls to triggers

A control does not own its trigger — the trigger is declared on the
parent card and references the control via the `element:` property:

```yaml
trk.d2.c2.t1:
  gesture:  tap
  element:  trk.d2.c2.s3.e1     # references the Save button
  action:
    type:   replace
    target: trk.d2.c3
    guard:  form.valid == true
```

## Notes
- `enabled-if` is distinct from `visible-if`. An element with
  `visible-if: false` does not render at all. An element with
  `enabled-if: false` renders but is inactive — greyed out and
  non-interactive. Use `enabled-if` when the user should see the
  control but not be able to use it (e.g. a Save button that is
  greyed until the form is valid).
- A `control` with `control-type: toggle` or `control-type: checkbox`
  has a binary state that changes on interaction. This state should
  be reflected in a bound field or a guard condition. If the toggle
  state needs to be persisted, it is a `field` not a `control`.
  Use `control` when the toggle fires an immediate action.
  Use `field` with `field-type: toggle` when the toggle value
  is part of a form to be saved later.
- Platform mappings: UIButton / UISwitch / UISegmentedControl (iOS),
  Button / Switch / RadioGroup (Android Material),
  TouchableOpacity / Switch (React Native).
