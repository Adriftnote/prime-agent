# Harness improvement (fork ops)

How this fork uses Prime's Continual Harness and `/refine`, and how that stays separate from enforcement/gates.

**`/refine` only changes Continual `H=(p,G,K,M)`. Gates live outside that write path and change only via reviewed PRs (or other server-side controls).**

Canonical evidence packet (Round 1 = e1·e4·e5):  
`https://github.com/Adriftnote/claude-archive/blob/main/continual-evidence/PRIME-PACKET.md`

Related principle (write-path, not strength):  
`https://github.com/Adriftnote/claude-archive/blob/main/wiki/entities/hard-is-position-not-strength.md`

## Two loops

| Loop | What it changes | Input | Output |
|------|-----------------|-------|--------|
| **① Continual / `/refine`** | `H = (p, G, K, M)` | Evidence packet D | Small **local** harness edits |
| **② Gates / governance** | Enforcement outside refine write path | Human-labeled fixtures; CI-hidden eval | Gate/review rules the refine loop cannot rewrite |

## Hard means position

A rule is hard only if the refine/proposer loop **cannot write that address**.

- **Server-side:** branch protection / required checks (when plan allows), CODEOWNERS *with* required reviews, CI-only hidden eval, credential-separated push, NAS bare `denyNonFastForwards`, backup refs.
- **Local:** anything the agent can Edit (repo hooks, githooks, `~/` configs) — soft even if runtime deny.

`.github/CODEOWNERS` on this stack is currently an **inventory + review hint** on Free private GitHub (no branch-protection enforcement). Treat it as a gate-file index until Pro/public or an alternate hard path above is live.

Irreversible local acts (dirty-tree wipe / F2-class): prefer **recoverability** (commit WIP early), not a fake server gate.

## What to measure for Prime (loop ①)

1. Round-1 failure→fix rows from `PRIME-PACKET.md` (e1·e4·e5)
2. Optional scores + which machine/env
3. Local `harness_state` before/after for smoke

Memory = **one-line rule + trigger + `canon:` path** (or `canon: self`).

## Promotion

1. `/refine` → **local** session harness only.
2. Smoke (edits map to packet; gates and `CLAUDE.md`/`AGENTS.md` untouched).
3. Human gate before **global** promote.
4. Loop ② only via reviewed PR / CI / server controls — never via `/refine`.

## Paste instruction for `/refine`

```
Prefer small LOCAL memory/prompt edits grounded ONLY in PRIME-PACKET.md Round 1 (e1 e4 e5).
Memory = one-line rule + trigger + "canon: <path|self>".
Empty edits if unsure. No global. No source/gate edits. No CLAUDE.md / AGENTS.md edits. No secrets.
```
