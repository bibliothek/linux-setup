#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# Same layout as the other app folders: scripts directly in optional/ apply to
# every OS, the ones in optional/<os>/ only to that one. Run through run.sh,
# which exports OS_DIR; fall back to resolving it here for a standalone call.
if [ -z "$OS_DIR" ]; then
  case "$(uname -s)" in
    Linux) OS_DIR="linux" ;;
    Darwin) OS_DIR="macos" ;;
    *)
      echo "Error: unsupported OS $(uname -s)."
      exit 1
      ;;
  esac
fi

# The OS folder comes first so an OS-specific script wins over a shared one of
# the same name.
OPTIONAL_DIRS=("$SCRIPT_DIR/optional/$OS_DIR" "$SCRIPT_DIR/optional")

# Every tool installable on this OS, by name, without the .sh suffix.
list_optional() {
  local dir script
  for dir in "${OPTIONAL_DIRS[@]}"; do
    for script in "$dir"/*.sh; do
      if [ -f "$script" ]; then
        basename "$script" .sh
      fi
    done
  done | sort -u
}

# Path of the script that installs a tool on this OS.
script_for() {
  local name="$1" dir
  for dir in "${OPTIONAL_DIRS[@]}"; do
    if [ -f "$dir/$name.sh" ]; then
      echo "$dir/$name.sh"
      return 0
    fi
  done
  return 1
}

# Function to get optional tools selection
get_optional_selection() {
  local optional_scripts=()
  local selected_flags=()
  local script_name

  while IFS= read -r script_name; do
    [ -n "$script_name" ] || continue
    optional_scripts+=("$script_name")
    selected_flags+=(--selected="$script_name")
  done < <(list_optional)

  if [ ${#optional_scripts[@]} -gt 0 ]; then
    echo "Optional tools installation:" >&2
    local mode=$(gum choose "all" "none" "custom")

    case "$mode" in
      all)
        printf "%s\n" "${optional_scripts[@]}"
        ;;
      none)
        # Return empty
        ;;
      custom)
        echo "Select optional tools to install (use space to select, enter to confirm):" >&2
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
    [ -n "$selected" ] || continue
    if script=$(script_for "$selected"); then
      echo "Running $script..."
      bash "$script"
      echo "$script finished."
      echo "--------------------"
    fi
  done <<< "$SELECTED_OPTIONAL"
fi
