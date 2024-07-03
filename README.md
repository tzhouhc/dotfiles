# Dotfiles

Normal initialization:

```sh
git clone --recurse-submodules git@github.com:tzhouhc/dotfiles.git ~/.dotfiles
```

If running on AWS EC2, first set password for the default user:

```sh
sudo su -
passwd ubuntu
```

Then proceed with installation (recommend doing so inside of `tmux`):

```sh
~/.dotfiles/install.sh
~/.dotfiles/deploy.sh
```

If cloned without `--recurse-submodule`:

```sh
git submodule update --init --recursive
```

# Requirements

Latest zsh configurations require [Nerd Fonts](https://www.nerdfonts.com/)
support at major version 3. Powerline symbols is also required. Use of fonts
like `Cascadia Code NF` or `JetBrains Nerd Font Mono` is recommended.

The main installation script requires `sudo` access to run the initial
installation of tools; specific installations using `cargo` or `homebrew` do
not.

# Install tools

If additional tooling is required, run the `install.sh` script. It should call
the other installation scripts automatically.

> [!NOTE]:
> `cargo_optional.sh` is not invoked as part of the standard installation
> process, as none of the tools within are used in the other scripts in this
> setup.

## Neovim

Downloaded using `bob-nvim` which is part of the rust installation.

# Tools

## Scripts

A number of custom scripts are available in `.dotfiles/bin`; this is
automatically added to the `$PATH` env var as part of the `zshrc`.

## Just

A `justfile` is provided for a couple of frequently used commands.

## Templater

The `templates` dir under `xdg_configs` stores what are essentially project
templates that can be used to quickly replicate a standard setup in a directory
by using the `tmpl` script.

For each template directory, there are usually a number of files that will be
copied over to the new project directory upon invocation of the command.
However, there are also a couple of special cases:

- An `info` plaintext file is expected and will be used to provide a short
  readable summary of the template dir.
- A `prep` shell script, if provided, will be sourced in the destination
  directory, and then removed.
- A `dot-envrc` file, if provided, will be copied and then renamed to `.envrc`
  in order to trigger the `direnv` tool. While this behavior follows that of
  stow, it is not currently done for other typically hidden files.

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

# Imports

A number of the zsh scripts can be sourced for effect:

- `$HOME/.zsh/base.zsh` encapsulates all the `PATH` and other env variables
  changed in the regular zsh shell session, as well as a large number of
  functions that could be useful.
- If the full set of functions are not needed, then `$HOME/.zsh/env/path.zsh`
  provides access to regular tools from `homebrew`, `rust`, etc.
