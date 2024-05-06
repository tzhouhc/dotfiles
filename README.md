# Dotfiles

Normal initialization:

```sh
git clone --recurse-submodules git@github.com:tzhouhc/dotfiles.git ~/.dotfiles
~/.dotfiles/deploy.sh
```

If cloned without `--recurse-submodule`:

```sh
git submodule update --init --recursive
```

# Install tools

If additional tooling is required, run the `install.sh` script.

## Neovim

Downloaded using `bob-nvim` which is part of the rust installation.

# Requirements

Latest zsh configurations require `Nerdfont` support.

# Trouble Shooting

## Gnu CoreUtils

It's important for most of the scripts used in this repo that the system
coreutils is the GNU version, as opposed to the BSD version.

# Guidelines

## Configs

The `configs` directory contains dotfiles and dot config directories that should
be symlinked to `$HOME`.

The `xdg_configs` directory contains dotfiles and dot config directories that
should be symlinked to `$XDG_CONFIG_HOME`, which is typically `$HOME/.config`.

These symlinks are managed with `stow`.


## Running Commands

The `zsh/functions.zsh` file contains shell tools that can be used in the
command line for convenience -- if something cannot be remembered or is part of
some other frequently used command, then it probably don't belong.

The `bin` directory is on the PATH env var and should include portable scripts
that are slightly more involved than a typical shell function, or are needed to
run in contexts beyond the commandline or zshrc -- e.g. as part of other
scripts.

`lib/navi` contains recipes that typically involve some params, but are not
worth creating special shell functions to run.

The `justfile` contains commands that could potentially involve some kind of
dependency, or are otherwise more context-aware -- associated with specific
repos, for example.

## Shortcuts

Given the amount of keyboard interactions needed and involved, there needs to
some kind of principle with respect to the keyboard shortcuts set in various
contexts.

### Tmux
Tmux options should primarily be restricted to either using the tmux prefix
`c-b`, or in rare occasions, using the META modifier, and avoid CTRL modifiers.

The reasoning is that it should let almost all other modifier keys go through.

### Shell
The commandline is almost all commands, as the name would suggest, so shortcuts
should mainly focus on options that facilitate quick insertion of content, and
use the CTRL modifier. The META modifier should be used to basically indicate
alternate modes of the same shortcut -- e.g. searching for files under current
directory with `c-o` or across current repo with `m-o` (not implemented).

### Vim
More sophisticated actions should be handled by lua functions and mapped using
`commands.lua`. Simple actions should be tied to regular keys in normal mode,
and modifier shortcuts should try to replicate their function in the shell where
possible to ensure uniformity and reduce memory burden.

META modifiers should take care to avoid Tmux ones.

### OS
With macOS, system level shortcuts almost always use CMD. Custom, global ones
should try not to be modified with solely META or CTRL.
