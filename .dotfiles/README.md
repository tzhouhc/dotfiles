# Dotfiles

Normal initialization:

```sh
git clone --bare git@github.com:tzhouhc/dotfiles.git $HOME/.dotfiles.git
alias dfg='git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME'
dfg checkout -f
dfg submodule update --init --recursive
cp $HOME/.dotfiles/ref_git_config $HOME/.dotfiles.git/config

```

## Submodule

In the `config` file in the bare repo dir, ensure that the submodule
has `ignore = all`. This makes it so that git does not care about the versioning
of the submodule.

This should be handled by default via the reference git config file.

## Remote Branch Issue

Possible check [this
link](https://stackoverflow.com/questions/22446446/cannot-setup-tracking-information-starting-point-origin-master-is-not-a-branc).

## Other hosts

If running on AWS EC2, first set password for the default user:

```sh
sudo su -
passwd ubuntu
```

Then change the default shell:

```sh
sudo apt-get install -y zsh
chsh
```

Then proceed with installation (recommend doing so inside of `tmux`):

```sh
~/.dotfiles/install.sh
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

## Zsh slowness

Might be due to `oh-my-posh` checking for updates. Run
`oh-my-posh disable notice` to prevent.

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
worth creating special shell functions to run, or one-off commands that don't
need dedicated scripts.

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

# External Dependencies

Due to various constraints, not _all_ tooling and systems or configurations are
recorded in the dotfiles repo. The external dependencies are noted here:

## Lolcate database

For working with the custom version of `cd`, a `lolcate` database named `dirs`
that searches and indexes are directories in relevant locations is required.
That is, one should run

```sh
lolcate --create --db dirs
```

and setup its `config.toml` with

```toml
skip = "Files"
```

and then run

```sh
lolcate --update --db dirs
```

and possibly add it to crontab:

```cron
0 22 * * *   /Users/tingzhou/.cargo/bin/lolcate --update --db dirs &>/dev/null
```

## Fonts

[Cascadia Code](https://github.com/microsoft/cascadia-code) alone is the
recommended font to use for this repo -- that is, I haven't really tested it
with any other font. Other Nerdfont-enabled fonts should work, but there might
be minor display issues?

Also, Nerdfont v3 is required.

## MacOS Configs

### `at` and `atrun`

To use `at` to schedule jobs, `atrun` must first be enabled by running

```sh
launchctl load -w /System/Library/LaunchDaemons/com.apple.atrun.plist
```

### Detachable CMUS

[Source](https://github.com/cmus/cmus/wiki/detachable-cmus)
