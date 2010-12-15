if [[ "root" != "$USER" && -s "$HOME/.rvmrc" ]] ; then
  source "$HOME/.rvmrc"
fi

if [[ "$rvm_path" = "$HOME/.rvm" ]] ; then
  if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    source "$HOME/.rvm/scripts/rvm"
  fi
else
  umask g+w
  export rvm_selfcontained=0
  export rvm_prefix="/usr/local/"
  if [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
    source "/usr/local/rvm/scripts/rvm"
  fi
fi