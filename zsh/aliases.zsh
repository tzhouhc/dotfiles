alias vim=supervim
alias vi=nvim  # in case multiple open vim windows are needed
alias g=git
alias v=supervim
alias lvim="LEANVIM=true nvim"
alias ovim="nvim -u ~/.vim/vimrc"
alias b=bat
alias clear="clear -x"  # keep scrollback
alias clear_nvim_cache="rm ~/.local/share/nvim/swap/*"

if type logo-ls >/dev/null 2>&1; then
  alias l=logo-ls -a
fi

# kek
alias :w="echo 'you are not in vim'"
alias :q="echo 'you are not in vim'"
alias :wq="echo 'you are not in vim'"

# convenience
alias j=jump

# BSD or GNU?
if [[ $COREUTILS_VER == GNU ]]; then
  alias ls='ls -N --color -h --sort=extension --group-directories-first -v'
else
  alias ls='ls -G'
fi
alias sed='sed -E'

alias vimdiff='nvim -d'

# typo
alias claer=clear
alias cl=clear

# customize calling
alias gtop="TERM='xterm' gtop"

if [[ $IS_PERSONAL_COMPUTER == "true" ]]; then
  alias open=open_and_switch
fi

if [[ $IS_GOOGLE == "true" ]]; then
  # dev
  alias p=p4
  alias g=git
  alias h=hg
  alias mdformat=/google/data/ro/teams/g3doc/mdformat
  alias bb="blaze build -c opt"
  alias br="blaze run -c opt"
  alias bt="blaze test"
  alias bigtable="/usr/bin/bt"
  alias wiki="g4d ting-wiki@"
  alias pastebin="/google/src/head/depot/eng/tools/pastebin"
  alias buildfix='/google/data/ro/teams/ads-integrity/buildfix'
  alias mkredirect='/google/src/head/depot/google3/corp/g3doc_contrib/tools/mkredirect/mkredirect.sh'
  alias dreampipe="/google/data/ro/teams/dreampipe/dreampipe"
  alias conduit="/google/data/ro/teams/conduit/conduit/conduit_live/conduit"
  alias napa="/google/data/ro/teams/napa/tools/napa"
  alias sqlp="/google/data/ro/teams/sqlp/sqlp"
  alias bluze="/google/bin/releases/blueprint-bluze/public/bluze"
  alias gpython="/google/bin/releases/gpython-team/gpython/gpython.par"
  alias lfd_cli="/google/data/ro/projects/logs/lfd_cli"
  alias logsutil="/google/data/ro/projects/logs/logsutil"
  alias fu=fileutil
  alias p4p="p4 p"
fi
