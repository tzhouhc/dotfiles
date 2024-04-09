if ! zgen saved; then
  # plugins
  # shell prompt creator
  zgen load romkatv/powerlevel10k powerlevel10k
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-autosuggestions
  zgen load ael-code/zsh-colored-man-pages
  # save all to init script
  zgen save
fi
