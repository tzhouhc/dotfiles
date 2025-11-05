# Ting's Top Ten Terminal Tricks

I try to sort them by the key of QoL Improvement divided by the combined effort
to install, setup and learn the relevant tooling. Descending order so if you
want you can just do like one thing from the top and be done.

**Assumptions**:

- You are using a modern shell like bash of zsh. If you are using fish you
  _probably_ don't need me telling you what you should use.
- You know where your shell's rc file `.bashrc` or `.zshrc` are and can edit
  them comfortably.

## 1 - Directory Teleport

Description: lets you `cd`, but instead of only up or down the file system tree,
you teleport by directory name instead.

[Setup](https://github.com/ajeetdsouza/zoxide)

Additional helpful setup that you can put into your config, which makes `cd`
more like an omni-cd that will seldom fail:

```sh
# combination of zoxide and a more liberal cd-experience:
#   - jumps to home if no args given
#   - jumps to the containing dir if given a file
#   - jumps to a dir if it _is_ a dir
#   - jumps to zoxide query if none of the above
function smart_cd() {
  if [ $# -eq 0 ] || [ -z "$1" ] ; then
    # no arguments, go home by default
    cd
  elif [ -d "$1" ]; then
    # argument is a current dir; go into it
    cd "$1"
  elif [ -f $1 ] ; then
    # argument is a file; go to containing dir
    cd "$(dirname $1)"
  else
    z "$1"
  fi
}

# Replace cd with `smart_cd` iff zoxide is installed.
if type zoxide &>/dev/null; then
  alias cd=smart_cd
fi
```

## 2 - Reverse History Search

Description: search through your command history in a more interactive fashion.

[Setup](https://docs.atuin.sh/#quickstart)

## 3 - LazyGit

Git, in commandline, but a terminal user interface!

[Setup](https://github.com/jesseduffield/lazygit?tab=readme-ov-file#installation)

I am not responsible if you forget how to use raw `git` after adopting this
for a while.

## 4 -

## 5 - Terminal Multiplexing

I have two recommendations -- you can either learn and use
[tmux](https://github.com/tmux/tmux/wiki) or [zellij](https://zellij.dev/), both
are terminal multiplexers. If that word sounds too big, think of them as being
able to give you new "tabs" and splits on your terminal session so that you get
more concurrent sessions at once.

Both also introduce their own non-trivial learning process. `zellij` has a set
of keybinds that is compatible with `tmux`, is a newer product with some fancy
new features like a more flexible floating pane, but also relatively lacks
polish.
