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

## Layout

`run.sh` walks four folders in order and runs the scripts that apply to the
current OS:

```
sudo/                 sudo access and passwordless sudo
apps/prerequisites/   what the rest of the run needs (brew, gum, node, ...)
apps/optional/        offered through a gum picker
apps/required/        the tools always installed
config/               dotfiles, git, shell, nvim, ...
```

Which OS a script applies to is decided by **where it lives**, not by a `case`
inside it:

| Applies to | Goes in |
| --- | --- |
| both, same steps | the folder itself, e.g. `apps/required/bat.sh` |
| one OS only | that OS subfolder, e.g. `apps/required/linux/wl-clipboard.sh` |
| both, different steps | both OS subfolders, e.g. `apps/optional/{linux,macos}/firefox.sh` |

The OS subfolders are `linux` and `macos`. `run.sh` is the only place that maps
`uname` to one of them; scripts themselves never check the OS. (Checking the
*architecture* with `uname -m` is fine and still happens in a few Linux
scripts.)

Within a folder, shared and OS-specific scripts run **interleaved, ordered by
file name**. Plain names are enough when order does not matter; add a numeric
prefix when it does, and the prefix orders a shared script against an
OS-specific one:

```
apps/prerequisites/10_brew.sh              installs Homebrew
apps/prerequisites/linux/11_brew-gcc.sh    ... then Linux adds brew's gcc
apps/prerequisites/12_gum.sh               ... then gum, on both
```

Steps shared between two OS-specific installs belong in their own script rather
than being copied into both subfolders. Where that shared step is configuration,
it belongs in `config/`: `apps/required/linux/zsh.sh` installs zsh where macOS
already ships it, and `config/00_oh-my-zsh.sh` then sets up Oh My Zsh on both —
prefixed because it has to run before `config/10_dotfiles.sh` replaces
`~/.zshrc` with a link.
