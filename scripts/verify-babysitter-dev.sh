#!/usr/bin/env bash
# Verificação mínima local antes de abrir PR: compila o SDK e executa o smoke do CLI
# (equivalente ao que o job "SDK smoke CLI" faz na matriz do CI).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

RUNS_DIR="${BABYSITTER_VERIFY_RUNS_DIR:-$(mktemp -d /tmp/babysitter-dev-verify.XXXXXX)}"
export BABYSITTER_VERIFY_RUNS_DIR="$RUNS_DIR"
cleanup() {
  if [[ "${BABYSITTER_VERIFY_KEEP_RUNS:-}" != "1" ]] && [[ -n "${RUNS_DIR:-}" ]] && [[ -d "$RUNS_DIR" ]]; then
    rm -rf "$RUNS_DIR" 2>/dev/null || true
  fi
}
trap cleanup EXIT

echo "== npm run build:sdk =="
npm run build:sdk

echo "== npm run smoke:cli (workspace @a5c-ai/babysitter-sdk) =="
npm run smoke:cli --workspace=@a5c-ai/babysitter-sdk -- --runs-dir "$RUNS_DIR"

echo "OK: build + CLI smoke passaram."
