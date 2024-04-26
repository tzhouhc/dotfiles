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

# summarily, no nerd font, no powershell, use simple ascii where possible
export FALLBACK_MODE=false
