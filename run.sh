#!/usr/bin/env bash
# Shadow of the Pyramid — launcher
# Requires Godot Engine 4.x (https://godotengine.org/download)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR/pyramid"

# Search for a Godot 4 binary
GODOT=""
for candidate in godot4 godot "godot4-bin" "godot-bin" Godot; do
    if command -v "$candidate" &>/dev/null; then
        GODOT="$candidate"
        break
    fi
done

# Also check common manual-install locations
if [ -z "$GODOT" ]; then
    for path in \
        "$HOME/Desktop/Godot_v4"*"_linux.x86_64" \
        "$HOME/Downloads/Godot_v4"*"_linux.x86_64" \
        "$HOME/.local/bin/godot" \
        "/opt/godot/godot" \
        "/usr/local/bin/godot4" ; do
        # expand glob
        for expanded in $path; do
            if [ -x "$expanded" ]; then
                GODOT="$expanded"
                break 2
            fi
        done
    done
fi

if [ -z "$GODOT" ]; then
    echo "ERROR: Godot Engine 4.x not found."
    echo ""
    echo "Please install Godot 4 from https://godotengine.org/download"
    echo "and make sure it is on your PATH, or place the binary in ~/Desktop or ~/Downloads."
    exit 1
fi

echo "Using Godot: $GODOT"
exec "$GODOT" --path "$PROJECT_DIR"
