# Gadgets

A "Gadget" is a shell script that provides an `fzf` list with some sort of
preview for each entry, and upon selecting one (or potentially more) items,
performs an *action* on them.

All of the gadgets are collected in a central tooling script and invoked via
Wezterm's API to create an "Alfred"-like experience.
