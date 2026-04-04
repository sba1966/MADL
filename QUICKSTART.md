# MADL Quickstart

> *You have a app idea. You want to build it with an AI coding agent.*
> *This is the order of operations.*

---

## Step 1 — Read it

Print the cheatsheet. One page, A4 landscape.

```
print/MADL_v0.1_cheatsheet.pdf
```

Read it in a chair, away from the screen. Not at the keyboard.
The five baskets, the ID pattern, the closed enumerations.
It should take ten minutes.

---

## Step 2 — Think about it

Before describing your app, draw the skeleton by hand.

Ask yourself:

- How many **decks** does my app have? Name each one.
- What **cards** (conditions) does each deck have?
- Which decks belong to a **stack**? Which to a **tabset**?
- What are the **entry** and **exit** of each deck?
- Which **elements** live on each card?
- What **services** does the app talk to?

You do not need to answer everything. You need to think in MADL terms
before you write anything down. The vocabulary is the discipline.

---

## Step 3 — Learn it

Assign IDs to everything you sketched in Step 2.

Choose your `{app_id}` — 2 to 6 characters, lowercase:

```
tracker     →  trk
finance     →  fin
daily log   →  dlog
health mon  →  hlth
```

Then cascade:

```
trk
trk.d1          deck 1: item selection
trk.d1.c1       card 1: default
trk.d1.c2       card 2: empty
trk.d2          deck 2: data entry
trk.d2.c1       card 1: default
trk.d2.c2       card 2: editing
trk.d2.c3       card 3: saving
trk.d2.c4       card 4: error
```

Write these IDs down. On paper if you prefer.
These IDs are permanent. They will appear in your spec,
in your code, and in every conversation with your agent.

---

## Step 4 — Use it

Write your `SCREENS.md` — the human-readable spec of your application.
This is the document you maintain. It lives in your repository root.

A minimal `SCREENS.md` looks like this:

```markdown
# SCREENS — {app_id}

## Atlas

| Deck     | Entry    | Exit     | Navigator   |
|----------|----------|----------|-------------|
| trk.d1   | trk.d1.c1 | trk.d1.c1 | trk.nav.stk1 |
| trk.d2   | trk.d2.c1 | trk.d1.c1 | trk.nav.stk1 |
| trk.d3   | trk.d3.c1 | trk.d2.c1 | trk.nav.tab1 |

## Decks

### trk.d1 — Item Selection
| Card     | Name    | States / notes          |
|----------|---------|-------------------------|
| trk.d1.c1 | default | list of items            |
| trk.d1.c2 | empty   | no items yet             |

### trk.d2 — Data Entry
| Card     | Name    | States / notes          |
|----------|---------|-------------------------|
| trk.d2.c1 | default | blank form               |
| trk.d2.c2 | editing | form in progress         |
| trk.d2.c3 | saving  | write in flight          |
| trk.d2.c4 | error   | validation failed        |

## Key Transitions

| From         | Gesture    | Guard               | To           |
|--------------|------------|---------------------|--------------|
| trk.d1.c1.t1 | tap item   | —                   | trk.d2.c1    |
| trk.d2.c2.t1 | tap Save   | form.valid == true  | trk.d2.c3    |
| trk.d2.c2.t2 | tap Save   | form.valid == false | trk.d2.c4    |
| trk.d2.c2.t3 | tap Cancel | —                   | trk.d1.c1    |

## Services

| ID                      | Type  | Role              |
|-------------------------|-------|-------------------|
| trk.store.db            | store | local database    |
| trk.svc.host.gps        | host  | location          |
| trk.svc.cloud.auth      | cloud | authentication    |
```

Update this file every time the spec changes.
It is your source of truth — not the code, not the screenshots.

---

## Step 5 — Give your agent its file

Every new coding session starts with this file:

```
agents/MADL_v0.1_agent.md
```

Paste it, attach it, or include it in your agent's system prompt.
This file teaches the agent the MADL vocabulary, the ID rules,
the closed enumerations, and how to parse your descriptions.

Without it, the agent does not know what `trk.d2.c3` means.
With it, the agent knows exactly which file to open, which
component to change, and which state to target.

Do this at the start of every session. The agent does not remember
between sessions. The file is the memory.

---

## Step 6 — Give your agent the spec

After the agent file, give it your `SCREENS.md`.

Then speak in MADL:

```
"In trk.d2.c2, change the guard on t1 from form.valid == true
to form.valid == true && user.premium == true"

"Add a state_offline card to trk.d3 that shows a banner when
trk.svc.api is unreachable"

"The transition from trk.d1.c1.t1 should be sheet-up, not push"
```

The agent knows the deck, the card, the trigger, the condition.
It does not guess. It does not open every file looking for something
that might match. It goes directly to the right place.

---

## The loop

```
Think in MADL  →  Write SCREENS.md  →  Agent reads agent file
     ↑                                        ↓
Update SCREENS.md  ←  Review diff  ←  Agent writes code
```

Every change to the app starts with a change to `SCREENS.md`.
Every conversation with the agent includes the agent file.
The IDs are the thread that runs through everything.

---

## Common mistakes

**Skipping the agent file.** The agent will not know MADL.
It will invent its own vocabulary and your IDs will mean nothing.
Always start with `agents/MADL_v0.1_agent.md`.

**Changing IDs after assigning them.** IDs are permanent.
If `trk.d2` becomes the settings deck instead of data entry,
do not renumber it — rename it in the `name:` field and update
the atlas. The ID `trk.d2` remains `trk.d2` forever.

**Describing location instead of addressing it.**
"The button at the bottom right of the third screen" is not a MADL
reference. `trk.d3.c1.s3.e2` is. Use IDs in every conversation.

**Using screenshots as specs.** A screenshot is a rendering of
a moment in time. It has no ID, no state name, no transition map.
It cannot be diffed, searched, or handed to an agent as instructions.
`SCREENS.md` is your spec. Screenshots are illustrations at best.

---

*MADL v0.1  ·  the spec is the source of truth  ·  screenshots are not*
