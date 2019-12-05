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
