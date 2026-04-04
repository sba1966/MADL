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

- Has **34 terms** covering the full surface of a mobile application
- Reuses **6 WML terms** that still fit exactly
- Enforces **mandatory cascading IDs** that encode hierarchy at a glance
- Uses **4 closed enumerations** for gestures, transitions, overlays, and host capabilities
- Fits on **one A4 landscape cheatsheet**
- Is readable by humans and AI agents equally

---

## What MADL Is

A shared dictionary. A naming convention. A description standard.

When you write `trk.d2.c3.t1.a → trk.d3.c1` you have said: in the Tracker
app, deck 2, card 3, trigger 1's action navigates to deck 3 card 1. Anyone
who knows MADL — human or agent — knows exactly what that means and exactly
which file to open.

When you tell an AI coding agent *"change the guard on `trk.d2.c2.t1` so
it also checks `user.premium == true`"*, the agent knows the deck, the card,
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

## The Five Baskets

MADL organises every concept in a mobile application into five baskets.

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
└───────────────────────────┴────────────────┘
```

| Basket | Contains |
|---|---|
| **STRUCTURE** | `app` · `deck` · `card` · `layer` · `slot` |
| **NAVIGATION** | `atlas` · `stack` · `tabset` · `drawer` · `flow` · `entry` · `exit` |
| **INTERACTION** | `trigger` · `action` · `transition` · `guard` · `gesture` |
| **ELEMENTS** | `element` · `field` · `label` · `control` · `media` · `list` · `overlay` |
| **SERVICES** | `service` · `store` · `endpoint` · `binding` · `host` · `cloud` · `event` |

---

## The ID Convention

Every node in a MADL-described application has a mandatory cascading ID.
The ID encodes the full path from the app root. You never need a lookup
table to understand where something lives.

```
trk                         app: Tracker
trk.d2                      deck 2
trk.d2.c3                   card 3 of deck 2
trk.d2.c3.s1                slot 1 of that card
trk.d2.c3.s1.e2             element 2 in that slot
trk.d2.c3.t1                trigger 1 on that card
trk.d2.c3.t1.a              the action of that trigger
trk.svc.api.ep.save         the save endpoint of the api service
```

Rules:
- Lowercase. Dot-separated. No spaces. No special characters.
- `{n}` values are stable positive integers. Never reused after retirement.
- No ID exists without a corresponding spec declaration.

---

## Repository Structure

```
MADL/
├── README.md                    ← you are here
├── CHANGELOG.md                 ← version history
├── CONTRIBUTING.md              ← how to propose changes
│
├── agents/
│   └── MADL_v0.1_agent.md       ← instruction file for AI coding agents
│
├── print/
│   └── MADL_v0.1_reference.pdf  ← printable A4 reference booklet
│
└── src/
    ├── structure/               ← BASKET 1: what exists
    ├── navigation/              ← BASKET 2: how user moves
    ├── interaction/             ← BASKET 3: what user does
    ├── elements/                ← BASKET 4: what populates cards
    └── services/                ← BASKET 5: what the app connects to
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
    myapp.d1:
      entry: myapp.d1.c1
      exit:  myapp.d1.c1
      nav:   myapp.nav.stk1

  decks:
    myapp.d1:
      name: Home
      cards:
        myapp.d1.c1:
          name: default
        myapp.d1.c2:
          name: loading
```

**Reference a specific thing when talking to your agent:**

> "Change the guard on `myapp.d2.c1.t1` to also require `user.verified == true`"

> "Add a `state_error` card to `myapp.d3` that shows inline validation messages"

> "The transition from `myapp.d1.c1.t2` should be `sheet-up` not `push`"

---

## Status

**v0.1 — initial specification.**

The vocabulary is defined. The ID convention is stable. The five baskets
are established. This is a working draft open for scrutiny and challenge.

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

*MADL v0.1 · This document is the source of truth. Screenshots are not.*
