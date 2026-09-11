# Harness improvement (fork ops)

How this fork uses Prime's Continual Harness and `/refine`, and how that stays separate from enforcement/gates.

Canonical evidence packet for the next local refine:  
`https://github.com/Adriftnote/claude-archive/blob/main/continual-evidence/PRIME-PACKET.md`

Related principle (write-path, not strength):  
`https://github.com/Adriftnote/claude-archive/blob/main/wiki/entities/hard-is-position-not-strength.md`

## Two loops

| Loop | What it changes | Input | Output |
|------|-----------------|-------|--------|
| **① Continual / `/refine`** | `H = (p, G, K, M)` — prompt, subagents, skills, memory | Evidence packet D: failures → fixes, scores, traces | Small **local** harness edits |
| **② Gates / governance** | Enforcement outside the refine search space | Labeled violation/compliant fixtures; CI-hidden eval | Gate code / review rules placed where the refine loop cannot rewrite them |

`/refine` owns loop ① only. Gate evolution is not a refine reward target.

## Hard means position

A rule is only hard if the refine/proposer loop **cannot write that address**.

- **Server-side:** branch protection, required checks, CODEOWNERS-required review, CI-only hidden eval fixtures.
- **Local (repo or machine):** hooks, githooks, settings deny lists, `~/.` configs the agent can still Edit — soft even if they *deny* at runtime.

CODEOWNERS on gate surfaces keeps files in-repo but forces human review on edits when branch protection exists. Irreversible local acts (e.g. dirty-tree wipe) are handled with **recoverability** (WIP commits), not by pretending a server gate exists.

## What to measure for Prime (loop ①)

Feed `/refine` a small packet, not papers or full vault claims:

1. Repeated failure → fix rows (with locators to archive/vault episodes)
2. Optional scores + which machine/env produced them
3. Current local `harness_state` snapshot (before/after for smoke)

Memory entries should be **one-line rule + `canon:` pointer** to the archive/vault source — do not duplicate long rulebook prose into `M`.

## Promotion

1. Apply refine **local** to the session harness.
2. Smoke (edits map to evidence; gates untouched).
3. Human gate before any **global** harness promote.
4. Loop ② changes go through PR/CI/review — never through `/refine`.

## Paste instruction for `/refine`

```
Prefer small LOCAL memory/prompt edits grounded ONLY in PRIME-PACKET.md (or the attached evidence).
Memory content = one-line rule + "canon: <locator>" pointer.
Empty edits array if unsure. No global. No source/gate edits. No secrets.
```
