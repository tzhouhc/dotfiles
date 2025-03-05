# Hammerspoon

This is a set of lua scripts that interacts with macOS.

It's considerably more powerful and _sane_ compared to AppleScript.

## Installing the CLI

This can be done over the debugging console with

```lua
hs.ipc.cliInstall("/opt/homebrew")
```

which would link the relevant executables (really just
`/Applications/Hammerspoon.app/Contents/Frameworks/hs/hs`).

## HS Scripts

The `hs_runner` script in `bin` wraps around the `hs` binary and feeds it the
full path of the script file. It can be used directly in the shebang of HS
scripts.

## Common Pitfalls In Scripting

* Pay close attention to whether a function is a function or a _method_.
* Use `hs.timer` for time related items instead of trying to make your own wait
    conditions.
