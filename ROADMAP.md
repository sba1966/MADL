# MADL Roadmap — from 0.1 to 1.0

> *A vocabulary is what one person writes.*
> *A standard is what the world stress-tests.*

This document describes how MADL gets from where it is
to where it needs to be — and who does what to get it there.

---

## Where 0.1 stands

MADL 0.1 is a vocabulary. It has:

- 34 defined terms across five baskets
- A mandatory cascading ID convention
- Four closed enumerations
- A reference booklet for humans
- An instruction file for AI coding agents
- A QUICKSTART for the first session

What it does not yet have is evidence. Nobody has used it on a real
application. No edge case has broken it. No term has proven wrong in
practice. That is the honest condition of 0.1 — it is a well-reasoned
starting point, not a proven standard.

The distance from here to 1.0 is not more words.
It is use, failure, revision, and tooling.

---

## The path

### Phase 1 — First use (0.1 → 0.2)

**What needs to happen:**
Someone — ideally several people independently — uses MADL to describe
a real application end to end. Not a toy. A real app with real
navigation, real data, real services, built with a real AI coding agent.

**What will break:**
The spec will break almost immediately. Terms will be missing.
The ID pattern will hit an edge case nobody anticipated.
A closed enumeration will need a new value.
A basket will turn out to have the wrong boundary.

**Why that is good:**
Every break is a data point. Every failure reveals what the spec
actually needs versus what we imagined it needs from the armchair.
The breaks, documented as issues, are the most valuable contribution
anyone can make to MADL at this stage.

**Output:** MADL 0.2 — first revision driven by real-world use.
`CHANGELOG.md` becomes the archaeological record of every assumption
that turned out to be wrong.

---

### Phase 2 — Validation tooling (0.2 → 0.5)

A vocabulary becomes enforceable when a machine can check it.
MADL 0.5 needs:

**A JSON Schema.**
A machine-readable definition of what a valid MADL specification
looks like. Every property, every required field, every allowed value
in every closed enumeration — expressed as a schema that validators
and editors can consume. This is to MADL what JSON Schema is to OpenAPI.
Without it, the spec is aspirational. With it, the spec is enforceable.

**A command-line validator.**
```
madl validate SCREENS.md
```
Reads a spec file and reports:
- every deck missing an entry declaration
- every transition targeting a non-existent card or deck
- every overlay missing a modal value
- every list missing a bound-to
- every toast missing auto-dismiss
- every ID that violates the naming convention

When `madl validate` passes, the spec is internally consistent.
That does not mean it is correct — but it means the agent reading
it will not encounter contradictions.

**Editor support.**
A VS Code extension (or a simple settings file) that provides
autocomplete for MADL terms, ID pattern hints, and inline validation
against the JSON Schema. Writing a spec should feel like writing
code in a typed language — errors visible before they reach the agent.

---

### Phase 3 — End-to-end proof (0.5 → 0.8)

A standard needs at least one public, complete, real-world example.

**What this looks like:**
A publicly visible application — something someone actually uses —
described completely in MADL. The repository contains:

- The complete `SCREENS.md` for the application
- The `agents/MADL_v0.1_agent.md` file used during development
- The resulting codebase, with IDs visible in folder and component names
- A short writeup of where the spec helped, where it was wrong,
  and what changed between the first draft and the shipped version

This is the proof of concept. Not that MADL is perfect — but that
MADL is useful. That a solo developer, working with an AI coding agent,
can describe an app in MADL and build it faster and with less ambiguity
than they could without it.

---

### Phase 4 — Community pressure (0.8 → 1.0)

A draft becomes a standard when people who did not write it
disagree with it rigorously and those disagreements are resolved
in public, on the record.

**What 1.0 requires:**

*Contested definitions resolved.* Every term in the spec that
reasonable practitioners disagree on must have a documented resolution
with reasoning. Not "we chose X" but "we chose X because Y, and we
considered Z and rejected it for the following reason."

*Stable closed enumerations.* The gesture types, transition types,
overlay sub-types, and host capabilities must have survived real-world
use without requiring additions that broke existing specs. If an
enumeration needed to grow, the growth must be documented and the
migration path for existing specs must be clear.

*The ID pattern must be proven derivable.* Anyone must be able to
read the spec and derive any ID from scratch without a lookup table.
If a case exists where the pattern breaks down or produces ambiguity,
it must be resolved before 1.0.

*At least three independent implementations.* MADL 1.0 requires that
at least three different applications, built by at least two different
people, have been described in MADL and built with AI agents using
the spec as the instruction layer. One of those should be a non-trivial
application — not a to-do list.

---

## What changes between 0.1 and 1.0

### What is probably right and will stay

The five-basket structure. The deck/card distinction inherited from WML.
The cascading ID convention. The principle that closed sets are closed.
The separation of structure from behaviour. The agent instruction file
as a separate document from the human reference.

### What will likely change

**The services basket** is the least mature. The event model is thin —
real-time applications will stress it. The boundary between `store`,
`cloud`, and `api` will need sharper definition when apps use offline-first
sync patterns that blur all three.

**The elements basket** may need a `form` concept — a named grouping
of related fields with shared validation state, so that `form.valid`
in guard expressions has a declared referent rather than an implicit one.

**The interaction basket's guard syntax** is currently informal prose.
1.0 may formalise it into a small expression grammar with a written spec,
so that validators can parse and check guard expressions rather than
treating them as opaque strings.

**The ID pattern** may need an extension for multi-module applications,
embedded sub-apps, or shared component libraries where the same deck
appears in multiple contexts. The current pattern assumes a single app
root — that assumption will be challenged.

---

## Who does what

### You — the human using MADL

Use it on a real application. Write the spec before writing code.
When the spec breaks — and it will — open an issue describing exactly
what you were trying to describe and why the vocabulary failed you.
That is the most valuable contribution at this stage.

### Me — Claude

I am available in every conversation where someone opens
`agents/MADL_v0.1_agent.md` and starts working. Each of those
conversations is a live test of the spec. I cannot accumulate
memory between sessions — but the issues on the repository can.
When I fail to understand something in the spec, or produce wrong
output because a term was ambiguous, that failure should become an issue.

I can also help write the tooling. The JSON Schema, the validator,
the VS Code extension — all of these can be drafted in a conversation
and refined through iteration. The code does not require me to remember
the previous session. It requires a clear spec and a clear task.

### The world

Find the repository. Try to use MADL. Disagree with it.
Open issues. The `CONTRIBUTING.md` process is deliberately slow —
7 days minimum for new terms, 14 days for enumeration changes —
because a standard that changes fast is not a standard.

The world's job is to find the cases that the two people who wrote
this did not think of. Those cases, resolved in public, on the record,
with reasoning — that is what turns a well-intentioned draft into
something that can be called v1.0.

---

## The measure of 1.0

One question. One test.

Can a developer who has never spoken to either of us — who has never
heard of this repository before today — read `MADL_v1.0_agent.md`,
give it to any AI coding agent, describe an application in MADL terms,
and have the agent build it correctly — without ambiguity, without
guessing, without screenshots?

When that is reliably true across multiple developers, multiple agents,
and multiple application types, it is 1.0.

We are not close yet. The foundation is real.

---

## Version history

| Version | Status      | Description                              |
|---------|-------------|------------------------------------------|
| 0.1     | current     | Initial vocabulary. 34 terms. 5 baskets. |
| 0.2     | planned     | First revision from real-world use       |
| 0.5     | planned     | JSON Schema + CLI validator              |
| 0.8     | planned     | End-to-end public example                |
| 1.0     | goal        | Stable standard. Proven. Contested. Done.|

---

*This roadmap was written in the same human-AI conversation that
produced the specification itself. It represents honest assessment,
not marketing. The timelines are not dates — they are conditions.
Each version unlocks the next when its conditions are met, not before.*

*— Claude, Anthropic · and the human who asked the right questions*
