# Contributing to MADL

## Principles

1. **Open an issue before a pull request.** Every change to the vocabulary
   needs discussion before it becomes a commit. This is a specification,
   not a codebase. Words have consequences.

2. **Closed sets stay closed.** The gesture, transition, overlay, and host
   capability enumerations are closed by design. Adding a value is a spec
   change — it requires an issue, discussion, and explicit consensus.
   Do not add values via pull request without prior issue resolution.

3. **One term, one file.** Each term lives in its own markdown file under
   the appropriate basket directory. Do not combine terms.

4. **The ID pattern is non-negotiable.** Any proposed term must include
   a cascading ID pattern consistent with the existing hierarchy.
   If the pattern cannot be derived without a lookup table, the term
   is not ready.

5. **Justify WML reuse or rejection.** When proposing a new term, state
   explicitly whether a WML/WAP equivalent existed and why it was or
   was not reused.

## Term file template

Each file in `src/` follows this structure:

```markdown
# {term}

## Definition
One sentence. No hedging.

## WML Origin
{WML element or attribute} | new

## ID Pattern
{pattern}  →  {example}

## Declaration Format
(yaml code block)

## Example
(concrete example using trk as the app)

## Notes
- Any constraints
- Any relationship to other terms
- Any contested aspects and how they were resolved
```

## Process for proposing a new term

1. Open an issue titled `[TERM] proposed: {term_name}`
2. State the problem the term solves that no existing term covers
3. Provide a draft term file following the template above
4. Await discussion — minimum 7 days before merge consideration
5. If accepted, open a pull request referencing the issue

## Process for proposing a closed set addition

1. Open an issue titled `[ENUM] add to {enumeration_name}: {value}`
2. State at least two real applications where the existing set is insufficient
3. Confirm the new value does not overlap semantically with an existing value
4. Await discussion — minimum 14 days before merge consideration

## What will not be accepted

- Terms that collapse the trigger / event / action distinction
- Terms that reintroduce "state" as a structural node (it is a runtime concept)
- Terms that make the ID pattern non-derivable without a lookup table
- Tooling, parsers, or generators (separate repository)
- Platform-specific terms (MADL is platform-neutral)
