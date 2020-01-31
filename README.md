# Dotfiles

Normal initialization:

```sh
git clone --resurse-submodule https://tzhouhc.github.com/dotfiles ~/.dotfiles
~/.dotfiles/deploy.sh
```

If cloned without `--recurse-submodule`:

```sh
git submodule update --init --recursive
```

# Install tools

If additional tooling is required, run the `install.sh` script.

# Requirements

Latest zsh configurations require `Nerdfont` support.

# Key Mappings Logic

### Tmux

The base tmux uses `Ctrl-b` as prefix.

Custom tmux short cuts uses `Meta` and modifier/numeric keys for convenience
features.

### Zsh

Zsh uses `Ctrl` directly for various key maps.

### Vim

Vim uses `Leader` for some operations, `Ctrl` for some others, and `Meta` with
letters to maximize utility while avoiding collision with Tmux.

Distinctions:

  * `Leader` is used to activate plugin features, if they have unique actions.
  * `Ctrl` is used for the series of `fzf` functions and other commonly used to
  make stuff happen make things happen.
  * `Meta` is currently reserved.
