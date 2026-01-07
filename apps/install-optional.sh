#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# Function to get optional tools selection
get_optional_selection() {
  local optional_dir="$SCRIPT_DIR/optional"
  [ -d "$optional_dir" ] || return

  local optional_scripts=()
  local selected_flags=()

  for script in "$optional_dir"/*.sh; do
    [ -f "$script" ] || continue
    local script_name=$(basename "$script" .sh)
    optional_scripts+=("$script_name")
    selected_flags+=(--selected="$script_name")
  done

  if [ ${#optional_scripts[@]} -gt 0 ]; then
    echo "Optional tools installation:"
    local mode=$(gum choose "all" "none" "custom")

    case "$mode" in
      all)
        printf "%s\n" "${optional_scripts[@]}"
        ;;
      none)
        # Return empty
        ;;
      custom)
        echo "Select optional tools to install (use space to select, enter to confirm):"
        gum choose --no-limit "${selected_flags[@]}" "${optional_scripts[@]}"
        ;;
    esac
  fi
}

# Get selected optional scripts
SELECTED_OPTIONAL=$(get_optional_selection)

# Run selected optional scripts
if [ -n "$SELECTED_OPTIONAL" ]; then
  echo "Running selected optional scripts..."
  while IFS= read -r selected; do
    script="$SCRIPT_DIR/optional/${selected}.sh"
    if [ -f "$script" ]; then
      echo "Running $script..."
      bash "$script"
      echo "$script finished."
      echo "--------------------"
    fi
  done <<< "$SELECTED_OPTIONAL"
fi
