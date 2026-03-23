#!/usr/bin/env bash
# Outputs the next sequential migration number (zero-padded to 3 digits)

MIGRATE_DIR="db/migrate"
mkdir -p "$MIGRATE_DIR"

last=$(ls "$MIGRATE_DIR"/*.rb 2>/dev/null | grep -oE '^[^_]+' | grep -oE '[0-9]+' | sort -n | tail -1)
next=$(( ${last:-0} + 1 ))
printf "%03d\n" "$next"
