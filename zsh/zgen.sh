if ! zgen saved; then
  zgen oh-my-zsh

  # plugins
  zgen load romkatv/powerlevel10k powerlevel10k
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-autosuggestions
  zgen load jocelynmallon/zshmarks
  zgen load ael-code/zsh-colored-man-pages
  zgen load rupa/z
  zgen load changyuheng/fz
  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/pip
  if type "hg" > /dev/null; then
    zgen oh-my-zsh plugins/mercurial
  fi
  # save all to init script
  zgen save
fi
