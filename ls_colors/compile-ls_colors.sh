#!/usr/bin/env bash

set -euo pipefail

SRC_FILE="LS_COLORS"
TARGET_FILE="../snippets/ls_colors.sh"

usage() {
  cat <<EOF
Usage: $(basename "$0") [options]

This script modifies an LS_COLORS definition file and converts it into a
dircolors-compatible shell snippet.

What it does:
  - Changes some colors.
  - Removes non-useful file formats.
  - Sorts the result and converts it using dircolors
  - Places result to correct directory.

Options:
  -t, --target <file>   Output file (default: ../snippets/ls_colors.sh)
  -h, --help            Show this help message

EOF
}

# --- args ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    -t|--target)
      TARGET_FILE="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

# --- checks ---
if [[ ! -f "$SRC_FILE" ]]; then
  echo "Error: source file '$SRC_FILE' not found in current directory." >&2
  exit 1
fi

TARGET_DIR="$(dirname "$TARGET_FILE")"
if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Error: target directory '$TARGET_DIR' does not exist." >&2
  exit 1
fi

# --- processing ---
TMP_FILE="$(mktemp)"

sed '/^DIR/s/38;5;30/38;5;39/' "$SRC_FILE" \
  | sed '/^FILE/s/0/38;5;14/' \
  | sed '/fortran/I d' \
  | sort > "$TMP_FILE"

dircolors --bourne-shell "$TMP_FILE" > "$TARGET_FILE"

rm -f "$TMP_FILE"
