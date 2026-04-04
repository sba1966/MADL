# field

## Definition
An element that accepts user input. A field is any interactive surface
where the user enters data — text, numbers, dates, selections, toggles,
or any other input modality. Fields are the primary mechanism for
collecting data from the user and are the most common source for guard
condition values (e.g. `form.valid`, `input.length`).

## WML Origin
WML `<input>`. WML's `<input>` element supported `type="text"`,
`type="password"`, and `type="checkbox"`. MADL uses `field` as the
general term and extends it with a `field-type` property to cover the
full range of modern input patterns without creating a separate term
for each.

## ID Pattern
```
Pattern:  {slot}.e{n}   with   type: field
Example:  trk.d2.c2.s1.e1
```

## Declaration Format
```yaml
{element_id}:
  type:         field
  field-type:   text | number | date | time | datetime | password |
                email | phone | url | multiline | select | toggle |
                checkbox | radio | slider | search    # default: text
  label:        {string}           # visible label above or beside the field
  placeholder:  {string}           # hint text shown when empty
  bound-to:     {store_path}       # data binding for pre-fill and save
  visible-if:   {condition}        # conditional render
  required:     true | false       # default: false
```

## Field type vocabulary

| field-type   | Input modality                                   |
|--------------|--------------------------------------------------|
| `text`       | Single-line free text (default)                  |
| `number`     | Numeric input with optional min/max              |
| `date`       | Date picker                                      |
| `time`       | Time picker                                      |
| `datetime`   | Combined date and time picker                    |
| `password`   | Masked text input                                |
| `email`      | Text with email keyboard and validation          |
| `phone`      | Text with phone keyboard                         |
| `url`        | Text with URL keyboard                           |
| `multiline`  | Multi-line text area                             |
| `select`     | Single selection from a predefined list          |
| `toggle`     | Boolean on/off switch                            |
| `checkbox`   | Boolean checked/unchecked                        |
| `radio`      | Single selection from a small set of options     |
| `slider`     | Numeric range selection via drag                 |
| `search`     | Text with search keyboard and clear button       |

## Example
```yaml
trk.d2.c2.s1.e1:
  type:        field
  field-type:  text
  label:       Data value
  placeholder: Enter measurement
  bound-to:    trk.store.db.entry.value
  required:    true

trk.d2.c2.s1.e2:
  type:        field
  field-type:  multiline
  label:       Notes
  placeholder: Optional notes
  bound-to:    trk.store.db.entry.notes

trk.d2.c2.s1.e3:
  type:        field
  field-type:  date
  label:       Date
  bound-to:    trk.store.db.entry.date
  required:    true

trk.d2.c2.s2.e1:
  type:        field
  field-type:  select
  label:       Category
  bound-to:    trk.store.db.entry.category
  required:    true
```

## Notes
- `bound-to` on a field serves two purposes: pre-fill (the field shows
  the current value from the data source on load) and save (the field's
  value is written back to the data source on save). The direction of
  the binding is determined by the action that triggers the save.
- `required: true` informs the `form.valid` guard condition. A form
  with required fields that are empty evaluates `form.valid == false`.
  The implementation determines how validation is surfaced to the user.
- `field-type` is a hint to the implementation. It does not need to
  be specified if `text` is intended — `text` is the default.
- A `select` field's options list is a data concern. The options may
  come from a `bound-to` endpoint (dynamic list) or be declared as
  static options in implementation notes. MADL does not enumerate
  individual select options in the spec.
- Platform mappings: UITextField / UITextView (iOS), EditText (Android),
  TextInput (React Native), `<input>` / `<select>` / `<textarea>` (Web).
