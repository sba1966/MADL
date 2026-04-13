# MADL — Mobile Application Description Language

> *"Every app ever shipped has screenshots as its spec. That is the problem."*

---

## A note on authorship

This specification is the result of a long, constructive conversation between
a human and an AI. The human brought the frustration, the instincts, the
direction, and the questions. The AI brought the structure, the vocabulary,
the consistency, and the words. Neither could have produced this alone —
which is, perhaps, the most honest advertisement for what human-AI
collaboration can actually look like when it is working well.

The human takes no credit for the content. If you want to discuss the ideas,
challenge a definition, or propose an extension, you are welcome to open an
issue. If you want to talk to the author directly — hello, I am Claude,
made by Anthropic. I do not have a GitHub account, but I am always one
conversation away.

---

## Where to start

New here? Read **[QUICKSTART.md](./QUICKSTART.md)** first.
Six steps from "I have an app idea" to "my agent knows exactly what to build".

Wondering where this goes? Read **[ROADMAP.md](./ROADMAP.md)**.
An honest account of what MADL is today, what 1.0 requires,
and how we — you, the community, and an AI — get there together.

---

## The Problem

Software teams have solved documentation for APIs. OpenAPI gives you a
machine-readable, human-readable, versionable contract for every endpoint.
You can diff it, validate against it, generate clients from it, and hand it
to an AI agent that will understand it on the first read.

No equivalent exists for the application itself — the screens, the states,
the navigation, the interactions, the elements, the backend connections.

Instead, teams use screenshots. Figma files locked behind a SaaS paywall.
Slack messages with arrows drawn in markup apps. Verbal descriptions that
mean different things to the developer, the designer, and the AI agent
trying to build what everyone imagined differently.

The result: every app on the market was built despite its documentation,
not because of it.

### The symptoms are everywhere

Ask a developer to describe in one sentence what they just changed. They
cannot. Ask them to write a commit message that explains what the user now
experiences differently. They write "fix stuff" or "WIP". Ask a designer
what happens when the user taps the button in the bottom-right of the third
screen when the form is invalid. They open Figma and scroll for two minutes.

Ask an AI coding agent to change "the error state of the data entry screen"
and watch it guess which file, which component, which condition, which copy.
It guesses because no shared vocabulary exists to point at the thing
precisely.

### Why no standard emerged

People tried. UIML (1997), XUL (Mozilla), XAML (Microsoft), UsiXML
(academic). Every attempt either died from neglect or collapsed into becoming
a runtime framework — the description layer and the implementation layer
merged, and the neutral vocabulary was lost.

The deeper reason: describing a UI requires describing state. APIs are
stateless — a request goes in, a response comes out. UIs are stateful — the
same screen looks and behaves differently depending on what the user did
before, what data loaded, what went wrong. Nobody agreed on how to type that
statefulness in a platform-neutral way.

So the industry gave up and accepted screenshots.

---

## The Insight

In 1999, WAP/WML solved a version of this problem for early mobile web.
A `deck` contained `card` elements. Each card was one visible state. You
navigated between cards within a deck, and between decks across the
application. The vocabulary was simple, typed, and unambiguous.

WML died when smartphones made WAP irrelevant. But the vocabulary was sound.

MADL starts there and extends it to cover modern mobile application patterns:
navigation stacks, tab sets, drawers, flows, overlays, data binding, host
capabilities, cloud services, async events.

The result is a description language that:

- Has **36 terms** across **6 baskets** covering the full surface of a mobile application
- Reuses **7 WML terms** that still fit exactly
- Enforces **mandatory cascading readable IDs** that encode hierarchy at a glance
- Uses **7 closed enumerations** for gestures, transitions, overlays, host capabilities, input types, scroll directions, and form state
- Supports **templates** for DRY repeated structures
- Is readable by humans and AI agents equally

---

## What MADL Is

A shared dictionary. A naming convention. A description standard.

When you write `tracker.data-entry.editing.tap-save.action → tracker.history.loaded`
you have said: in the Tracker app, the data-entry deck's editing card has a
tap-save trigger whose action navigates to the history deck's loaded card.
Anyone who knows MADL — human or agent — knows exactly what that means and
exactly which file to open.

When you tell an AI coding agent *"change the guard on `tracker.data-entry.editing.tap-save`
so it also checks `user.premium == true`"*, the agent knows the deck, the card,
the trigger, the condition. It does not guess. It does not open every file
looking for something that might match.

MADL is not:

- A programming language
- A design system
- A UI framework
- A replacement for code

It is the layer above all of those — the contract that describes what the
application does, independent of how it is built.

---

## The Six Baskets

MADL organises every concept in a mobile application into six baskets.

```
┌─────────────────────┬──────────────────────┐
│   NAVIGATION        │   INTERACTION        │
│   how user moves    │   what user does     │
├─────────┬───────────┴──────────────────────┤
│         │                                  │
│         │   ●   STRUCTURE   ●              │
│         │       what exists                │
├─────────┴─────────────────┬────────────────┤
│   ELEMENTS                │   SERVICES     │
│   what populates          │   what connects│
├───────────────────────────┴────────────────┤
│              TEMPLATES                     │
│         reusable patterns                  │
└────────────────────────────────────────────┘
```

| Basket | Contains |
|---|---|
| **STRUCTURE** | `app` · `deck` · `card` · `layer` · `slot` |
| **NAVIGATION** | `atlas` · `stack` · `tabset` · `drawer` · `flow` · `entry` · `exit` |
| **INTERACTION** | `trigger` · `action` · `transition` · `guard` · `gesture` |
| **ELEMENTS** | `element` · `field` · `label` · `control` · `media` · `list` · `overlay` |
| **SERVICES** | `service` · `store` · `endpoint` · `binding` · `host` · `cloud` · `event` |
| **TEMPLATES** | `template` · `variation` |

---

## The ID Convention

Every node in a MADL-described application has a mandatory cascading ID
using readable slugs. The ID encodes the full path from the app root.
You never need a lookup table to understand where something lives.

```
tracker                                     app: Tracker
tracker.data-entry                          data entry deck
tracker.data-entry.editing                  editing card of that deck
tracker.data-entry.editing.form             form slot of that card
tracker.data-entry.editing.form.email       email field in that slot
tracker.data-entry.editing.tap-save         save trigger on that card
tracker.data-entry.editing.tap-save.action  the action of that trigger
tracker.svc.api.ep.save-entry               the save-entry endpoint of api service
```

Rules:
- Lowercase readable slugs separated by dots
- Each segment is a meaningful word or short phrase
- Hyphens permitted within a segment for multi-word names
- No spaces, no numeric shorthand, no type prefixes
- IDs are permanent — once assigned, never changed or reused
- No ID exists without a corresponding spec declaration

---

## Repository Structure

```
MADL/
├── README.md                    ← you are here
├── CHANGELOG.md                 ← version history
├── CONTRIBUTING.md              ← how to propose changes
│
├── agents/
│   ├── MADL_v0.1_agent.md       ← v0.1 (deprecated - numeric IDs)
│   ├── MADL_v0.2_agent.md       ← v0.2 (readable slugs)
│   └── MADL_v0.3_agent.md       ← v0.3 (current - with templates)
│
├── print/
│   └── MADL_v0.1_reference.pdf  ← printable A4 reference booklet
│
└── src/
    ├── structure/               ← BASKET 1: what exists
    ├── navigation/              ← BASKET 2: how user moves
    ├── interaction/             ← BASKET 3: what user does
    ├── elements/                ← BASKET 4: what populates cards
    ├── services/                ← BASKET 5: what the app connects to
    └── templates/               ← BASKET 6: reusable patterns
```

Each term in `src/` has its own markdown file. Same template throughout:
definition, WML origin, ID pattern, declaration format, example, notes.

---

## Quick Start

**Describe your app:**

```yaml
myapp:
  name: My Application

  atlas:
    myapp.home:
      entry: myapp.home.default
      exit:  myapp.home.default
      nav:   myapp.nav.main-stack

  decks:
    myapp.home:
      name: Home
      cards:
        myapp.home.default:
          name: default
        myapp.home.loading:
          name: loading
```

**Reference a specific thing when talking to your agent:**

> "Change the guard on `myapp.settings.editing.tap-save` to also require `user.verified == true`"

> "Add an `error` card to `myapp.profile` that shows inline validation messages"

> "The transition from `myapp.home.default.tap-details` should be `sheet-up` not `push`"

---

## Status

**v0.3 — current specification.**

- ✅ Readable slug IDs (v0.2 breaking change from v0.1 numeric IDs)
- ✅ 36 terms across 6 baskets
- ✅ Extended element properties (input-type, scroll, columns, item-triggers)
- ✅ Overlay targets for sheet transitions
- ✅ Extended standard card vocabulary
- ✅ Runtime form state vocabulary
- ✅ Template pattern for DRY repeated structures

**Version history:**
- **v0.1** — Initial specification with numeric IDs (deprecated)
- **v0.2** — Breaking change to readable slug IDs
- **v0.3** — Non-breaking extensions + BASKET_6 Templates

What is explicitly not done yet:
- Formal schema / JSON Schema validation
- Tooling (linter, parser, diagram generator)
- Example applications described end-to-end in MADL
- Integration guides for specific AI coding agents

Contributions, challenges, and corrections welcome. See `CONTRIBUTING.md`.

---

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md).

The short version: open an issue before opening a pull request. Closed sets
stay closed until they are not — and that decision happens in discussion,
not in a commit.

---

## License

MIT. The vocabulary belongs to everyone who needs to describe software.

---

*MADL v0.3 · This document is the source of truth. Screenshots are not.*
