# unix-setup

My unix setup

## Quick Install

### Linux (Debian/Ubuntu)

```bash
command -v sudo >/dev/null 2>&1 || su -c "apt-get update && apt-get install -y sudo" && sudo apt-get update && sudo apt-get install -y git && git clone https://github.com/bibliothek/unix-setup.git && cd unix-setup && ./run.sh
```

### macOS

```bash
if ! xcode-select -p >/dev/null 2>&1; then xcode-select --install; echo "Finish the Command Line Tools install, then re-run this command."; else git clone https://github.com/bibliothek/unix-setup.git && cd unix-setup && ./run.sh; fi
```

The Command Line Tools provide `git`, so on a fresh machine the first run only
kicks off their installer. Wait for it to finish, then run the same command
again to clone and set up.
