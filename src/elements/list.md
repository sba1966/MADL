# list

## Definition
A repeating element that renders a collection of items bound to a
data source. A list is a single element in the spec that expands into
N rendered rows at runtime, where N is the count of items in the
bound collection. Each row follows the same template, defined by the
list's item schema. Lists are the primary pattern for displaying
history entries, search results, selection options, and any
collection of similar items.

## WML Origin
New. WML had no list concept — repeated content was not a first-class
pattern in WAP-era applications. MADL introduces `list` because
collections of data are the most common complex element in modern
mobile applications, and the list/item pattern requires explicit
specification: what is the data source, what does each item show,
and what happens when an item is tapped.

## ID Pattern
```
Pattern:  {slot}.e{n}   with   type: list
Example:  trk.d1.c1.s1.e1
```

## Declaration Format
```yaml
{element_id}:
  type:       list
  bound-to:   {endpoint_id | store_path}    # MUST — collection data source
  item:
    label:    {string | "{binding}"}        # primary item text
    sublabel: {string | "{binding}"}        # secondary item text — optional
    media:    {store_path | endpoint}       # item image/icon — optional
  visible-if: {condition}                   # optional
  empty-card: {card_id}                    # card to show when list is empty
```

## Example
```yaml
# Item selection list
trk.d1.c1.s1.e1:
  type:      list
  bound-to:  trk.store.db.ep.items
  item:
    label:   "{item.name}"
    sublabel: "{item.category}"
  empty-card: trk.d1.c2         # switches to empty card when no items

# History list (most recent first)
trk.d3.c1.s1.e1:
  type:     list
  bound-to: trk.store.db.ep.history
  item:
    label:   "{entry.value}"
    sublabel: "{entry.date}"

# Search results list
trk.d2.c4.s1.e1:
  type:     list
  bound-to: trk.svc.api.ep.search_results
  item:
    label:    "{result.title}"
    sublabel: "{result.description}"
    media:    "{result.thumbnail_url}"
```

## Connecting list item taps to triggers

A tap on a list item fires a trigger declared on the parent card.
The trigger references the list element, and the tapped item's
data is available to the action's guard and the target card:

```yaml
trk.d1.c1.t1:
  gesture: tap
  element: trk.d1.c1.s1.e1      # the list element
  action:
    type:   push
    target: trk.d2               # navigate to data entry with selected item
```

## Notes
- `bound-to` is MUST for list elements. A list without a data source
  has nothing to render. If the data source returns an empty collection,
  the list renders no items — use `empty-card` to specify a fallback
  card to show in this case.
- `empty-card` declares which card the deck should transition to when
  the list's collection is empty. This is a convenience — the same
  behaviour can be declared as a `system-event` trigger with a guard
  on `entry.count == 0`. Using `empty-card` makes the intent explicit.
- Item binding expressions use `{item.property}` syntax where `item`
  refers to a single record from the bound collection. The property
  names match the fields in the data source schema.
- A list does not paginate automatically. If pagination is required,
  declare a `scroll-end` trigger on the card that loads the next page
  and updates the bound collection. The list re-renders as the
  collection grows.
- Platform mappings: UITableView / UICollectionView (iOS),
  RecyclerView (Android), FlatList / SectionList (React Native),
  mapped array rendering (Web).
