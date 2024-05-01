if ! zgen saved; then
  # plugins
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-autosuggestions
  zgen load ael-code/zsh-colored-man-pages
  zgen load zsh-users/zsh-completions src
  # save all to init script
  zgen save
fi
