#!/usr/bin/env bash
# Idempotent Cloud Agent bootstrap for prime-agent.
# Runs after the repository is checked out. Safe to run repeatedly.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

# 1. Node workspace dependencies (installs exactly what package-lock.json pins).
npm ci

# 2. uv powers the Python REPL kernel that backs the RLM runtime. Install it once
#    into ~/.local/bin if it is not already available. The kernel bootstrap also
#    finds it at ~/.local/bin/uv even when it is not on PATH.
if ! command -v uv >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/uv" ]; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
export PATH="$HOME/.local/bin:$PATH"

# 3. Pre-build the Python kernel venv so the first agent turn does not pay the
#    one-time setup cost and can run offline afterwards. Best-effort: if it fails
#    (e.g. transient network), the agent bootstraps it lazily on first kernel use.
export PRIME_AGENT_INSTALL_UV=1
warm_script="$(mktemp --suffix=.mts)"
trap 'rm -f "$warm_script"' EXIT
cat > "$warm_script" <<EOF
import { ensureKernelPython } from "${repo_root}/packages/coding-agent/src/core/kernel/bootstrap.ts";
const python = await ensureKernelPython({ onProgress: (m) => console.log(m) });
console.log("kernel python: " + python);
EOF
if ! node_modules/.bin/tsx "$warm_script"; then
  echo "prime-agent kernel pre-warm skipped; it will bootstrap on first use."
fi
