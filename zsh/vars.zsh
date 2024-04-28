if uname -a | grep Tings > /dev/null; then
  export IS_PERSONAL_COMPUTER=true
else
  export IS_PERSONAL_COMPUTER=false
fi

if [[ -d "/google" ]] ; then
  export IS_GOOGLE=true
else
  export IS_GOOGLE=false
fi

# Now that PATH is set, check whether the coreutils on top of the list
# is BSD or GNU
if [[ -z $(ls --version 2>/dev/null | grep gnu) ]]; then
  export COREUTILS_VER=BSD
else
  export COREUTILS_VER=GNU
fi

# summarily, no nerd font, no powershell, use simple ascii where possible
export FALLBACK_MODE=false
