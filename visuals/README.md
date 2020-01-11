# LS_COLORS setup

## Tool

Requires `vivid`, which can be installed as `cargo install vivid`.

## Files

`filetypes.yml` defines the types that can be colorized.

`lscolors.yml` defines the colors and the color mappings.

`generate_ls_colors.zsh` creates a new `lscolors` file using the above data
files, which is then used by `env.zsh` to set the LS_COLORS variable.
