# Trouble Shooting

## Gnu CoreUtils

It's important for most of the scripts used in this repo that the system
coreutils is the GNU version, as opposed to the BSD version.

## Vim

### CoC

For the error

```
[coc.nvim] Unable to load global extension at
/home/daniel/.config/coc/extensions/node_modules/coc-ccls: main file
./lib/extension.js not found, you may need to build the project.
```

The solution is

```bash
cd ~/.config/coc/extensions/node_modules/coc-ccls
ln -s node_modules/ws/lib lib
```
