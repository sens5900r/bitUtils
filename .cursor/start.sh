#!/usr/bin/env bash
# Cloud Agent start phase for bitUtils.
#
# Launches a headless X server (Xvfb) on DISPLAY :99 so the Tcl/Tk GUI functions
# (bit_csv, bit_editor, bit_cp949, ...) can run without a physical display.
# Idempotent: does nothing if an X server is already up on :99.
set -euo pipefail

DISPLAY_NUM="${DISPLAY:-:99}"
LOCK="/tmp/.X${DISPLAY_NUM#:}-lock"

if [ -e "$LOCK" ] && xdpyinfo -display "$DISPLAY_NUM" >/dev/null 2>&1; then
  echo "Xvfb already running on $DISPLAY_NUM"
  exit 0
fi

# Clean up any stale lock from a previous boot before starting fresh.
rm -f "$LOCK" 2>/dev/null || true

echo "Starting Xvfb on $DISPLAY_NUM"
Xvfb "$DISPLAY_NUM" -screen 0 1280x1024x24 -nolisten tcp >/tmp/xvfb.log 2>&1 &

# Wait for readiness so downstream GUI code sees a working display.
for _ in $(seq 1 30); do
  if xdpyinfo -display "$DISPLAY_NUM" >/dev/null 2>&1; then
    echo "Xvfb ready on $DISPLAY_NUM"
    exit 0
  fi
  sleep 0.5
done

echo "ERROR: Xvfb did not become ready on $DISPLAY_NUM" >&2
cat /tmp/xvfb.log >&2 || true
exit 1
