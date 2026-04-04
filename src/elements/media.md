# media

## Definition
An element that displays image, video, or audio content. Media elements
are read-only display surfaces — they render content from a data source
or static asset but do not accept input. A media element may be
interactive (tappable to trigger an action) but that interactivity
is declared via a trigger on the parent card, not on the element itself.

## WML Origin
New. WML had `<img>` for images but no unified media concept. MADL
uses `media` as the unifying term because modern mobile applications
treat images, video, maps, charts, and audio players as variations
of the same pattern: a rendered surface bound to a data source.

## ID Pattern
```
Pattern:  {slot}.e{n}   with   type: media
Example:  trk.d3.c1.s1.e1
```

## Declaration Format
```yaml
{element_id}:
  type:        media
  media-type:  image | video | audio | map | chart | avatar | icon
               # default: image
  bound-to:    {endpoint_id | store_path | asset_path}  # SHOULD
  alt:         {string}          # accessibility description — SHOULD
  visible-if:  {condition}       # optional
  aspect:      {ratio}           # optional — e.g. "16:9", "1:1", "4:3"
```

## Media type vocabulary

| media-type | Description                                              |
|------------|----------------------------------------------------------|
| `image`    | Static or dynamic photograph, illustration, or graphic   |
| `video`    | Playable video content                                   |
| `audio`    | Playable audio content                                   |
| `map`      | Interactive or static map surface                        |
| `chart`    | Data visualisation — bar, line, pie, etc.                |
| `avatar`   | User or entity profile image, often circular             |
| `icon`     | Small symbolic graphic from an icon set                  |

## Example
```yaml
# Data-bound map using GPS
trk.d3.c1.s1.e1:
  type:       media
  media-type: map
  bound-to:   trk.svc.host.gps
  alt:        Current location map

# History entry chart
trk.d3.c1.s2.e1:
  type:       media
  media-type: chart
  bound-to:   trk.svc.api.ep.history_chart
  alt:        History trend chart
  aspect:     "16:9"

# User avatar on profile deck
trk.d8.c1.s1.e1:
  type:       media
  media-type: avatar
  bound-to:   trk.store.db.user.avatar_url
  alt:        User profile photo

# Static image from asset
trk.d9.c1.s1.e1:
  type:       media
  media-type: image
  bound-to:   assets/onboard_hero.png
  alt:        Welcome illustration
  aspect:     "4:3"

# Video with playback
trk.d10.c1.s1.e1:
  type:       media
  media-type: video
  bound-to:   trk.svc.cloud.storage.ep.intro_video
  alt:        Introduction video
```

## Notes
- `bound-to` on a media element points to the source of the content:
  a store path (URL or binary), an endpoint (returning a URL or stream),
  a host capability (e.g. GPS for maps), or a static asset path.
- `alt` is the accessibility description. It should be provided for
  all media elements that convey information. It MUST be provided
  for `image` and `avatar` types.
- A media element that is tappable (e.g. an image that opens a
  fullscreen view) is made interactive via a trigger on the parent
  card that references this element: `element: {media_element_id}`.
  The media element itself does not declare the trigger.
- `chart` media elements carry a `bound-to` that points to a data
  endpoint returning the chart dataset. The chart type (bar, line, etc.)
  is an implementation concern — MADL specifies that a chart is
  present, not which chart library or style is used.
- `map` bound to `trk.svc.host.gps` renders a live map centred on
  the device's current location. The map implementation (Apple Maps,
  Google Maps, Mapbox) is an implementation concern.
- Platform mappings: UIImageView / AVPlayerViewController (iOS),
  ImageView / MediaPlayer (Android),
  Image / Video (React Native), `<img>` / `<video>` / `<audio>` (Web).
