#!/usr/bin/env bash
# Babysitter CLI gate for this monorepo (IVA-1167): explicit pass/fail after SDK build.
# Run from repo root: npm run build:sdk && npm run verify:babysitter
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

CLI_MAIN="packages/sdk/dist/cli/main.js"
if [[ ! -f "$CLI_MAIN" ]]; then
  echo "verify:babysitter: SDK CLI not built. Run first: npm run build:sdk" >&2
  echo "  (expected file: $CLI_MAIN)" >&2
  exit 1
fi

echo "==> Babysitter health (cwd=$ROOT)"
node "$CLI_MAIN" health
code_health=$?
if [[ "$code_health" -ne 0 ]]; then
  echo "verify:babysitter: health failed (exit $code_health). See messages above." >&2
  exit "$code_health"
fi

echo ""
echo "==> Babysitter configure validate"
node "$CLI_MAIN" configure validate
code_cfg=$?
if [[ "$code_cfg" -ne 0 ]]; then
  echo "verify:babysitter: configure validate failed (exit $code_cfg). Fix env/config per output above." >&2
  exit "$code_cfg"
fi

echo ""
echo "verify:babysitter: OK (health + configure validate)"
