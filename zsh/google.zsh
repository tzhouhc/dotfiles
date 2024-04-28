# some google stuff
if [[ $IS_GOOGLE == "true" ]]; then
  if [[ -e '/etc/bash_completion.d/g4d' ]]; then
    source /etc/bash_completion.d/g4d
  fi

  # env vars
  export G4MULTIDIFF=1
  export P4DIFF='p4diff'

  # input method for linux
  export GTK_IM_MODULE=ibus
  export XMODIFIERS=@im=ibus
  export QT_IM_MODULE=ibus

  export DIR_HISTFILE="$HOME/.zsh_dir_history"
fi

# --------
# Google functions
# --------

# jump to java test folder of the same package
function jt() {
  if [[ $PWD =~ '(.*)/javatests(.*)' ]]; then
      cd "${match[1]}/java${match[2]}"
  else
      cd "${PWD/\/google3\/java//google3/javatests}"
  fi
}

function csfind() {
  # empty query to csfind gets data from the last query
  # so that one query can be reused multiple times
  if [[ $@ != '' ]]; then
    echo "Querying CS..."
    cs --nostats --local -n $@ 2>/dev/null | cut -d':' -f1-2 | cut -d'/' -f7- | sed 's/\:/ /' > ~/.last_cs
  else
    touch ~/.last_cs
  fi
  cat ~/.last_cs | fzf --preview "ln={2}; bat -H \$ln -r \$[\$[\$ln - 3] < 0 ? 0 : \$[\$ln - 3]]:\$[\$ln + 40] --theme zenburn /google/src/files/head/depot/{1}"
}

function csedit() {
  output=$(csfind $@)
  # allow ^c early escape
  if [[ $? == 0 ]]; then
    read -r file num <<< $(echo $output)
    if [[ $(g4pwd) != '' ]]; then
      # open local citc version so that we can start editing
      vim $(g4pwd)/$file +$num
    else
      # Read-only view into latest source
      vim /google/src/files/head/depot/$file +$num
    fi
  else
    exit $?
  fi
}

function cshere() {
  cs "file://depot/google3/$(pwd | cut -d'/' -f8-) $@"
}

# show current citc client full path
function g4pwd() {
  if [[ $PWD =~ '(/google/src/cloud/[^/]+/[^/]+)' ]]; then
    echo $match[1]
  fi
}

function g4name() {
  echo "$(g4pwd | rev | cut -d'/' -f1 | rev)"
}

# show current rel path under google3
function g4pwd2() {
  if [[ $PWD =~ '/google/src/cloud/[^/]+/[^/]+/google3/(.+)' ]]; then
    echo $match[1]
  fi
}

# build, then go to the blaze-out directory
function bbs() {
  [[ $PWD =~ '(/google/src/cloud/[^/]+/[^/]+)/(.*)' ]]
  citc_path=$match[1]
  blaze_path="$(blaze build $@ 2>&1 | grep blaze-out)"
  blaze_path=${blaze_path// /}
  if [[ ! -z $blaze_path ]]; then
    print -P "%F{green}Target built; cd-ing now"
    cd "$citc_path/google3/$(dirname $blaze_path)"
  else
    print -P "%F{red}Target not found; fix something maybe?"
    exit 1
  fi
}

# open test log in $EDITOR if test result is no good
# TODO: investigate why $() removes color from stderr
function btlog() {
  output=$(bt $@)
  if [[ $? != 0 ]]; then
    $EDITOR $(echo $output | grep "test.log")
  fi
}

# mark for google3 -- disregard the workspace and go to short-path
# this is needed over normal z since z no longer works if we change client
function g3mark() {
  if [[ $PWD =~ '(/google/src/cloud/[^/]+)/([^/]+)/google3/(.*)' ]]; then
    remainder=$match[3]
    echo "$1\t$remainder" >> ~/.g3marks
    sort ~/.g3marks | uniq > ~/.g3marks.bk
    cp ~/.g3marks.bk ~/.g3marks
    rm ~/.g3marks.bk
  else
    echo "Not in a google3 folder, simply use 'bookmark' instead."
  fi
}

function editmarks() {
  $EDITOR ~/.g3marks
}

# generate a link to CS for current directory
function cslink() {
  if [[ $PWD =~ '(/google/src/cloud/[^/]+)/([^/]+)/google3/(.*)' ]]; then
    remainder=$match[3]
    echo "https://source.corp.google.com/piper///depot/google3/$remainder/$1"
  fi
}

# generate a link to cider for current directory
function ciderlink() {
  if [[ $PWD =~ '(/google/src/cloud/[^/]+)/([^/]+)/google3/(.*)' ]]; then
    remainder=$match[3]
    file=$(local_file_list | sed s/\"//g)
    echo "http://cider-v/?ws=$(g4name)&files=//depot/google3/$(g4pwd2)/$file"
  fi
}

# cd to specified short-path under the piper client
function g4cd() {
  if [[ $1 == google3/* ]]; then
    cd "$(g4pwd)/$1"
  else
    cd "$(g4pwd)/google3/$1"
  fi
}

function g4do() {
  pushd "$(g4pwd)/google3" >/dev/null
  "$@"
  popd >/dev/null
}

# cd to current path but under blaze-bin instead
function g4bin() {
  if g4pwd2 | grep blaze-bin > /dev/null; then
  else
    cd "$(g4pwd)/google3/blaze-bin/$(g4pwd2)"
  fi
}

function p4cd() {
  set -o pipefail
  target=$(p4_change_list)
  if [[ $target != "" ]]; then
    cd $(echo $target | sed 's/[^\/]*$//')
  fi
}
# edit files that are open in the client
function p4d() {
  set -o pipefail
  target=$(p4_change_list)
  if [ $? -eq 0 ]; then
    p4 diff $target
  fi
}
# edit files that are open in the client
function p4e() {
  set -o pipefail
  if [[ $@ == '' ]]; then
    target=$(p4_change_list)
  else
    target="$(g4pwd)/$@"
  fi
  if [[ $target != "" ]]; then
    # extra echo to prevent editor from consuming all as a single line
    supervim $(echo $target)
  fi
  set +o pipefail
}

# select files to revert in the client
function p4_choose_revert() {
  p4 revert $(p4_full_change_list)
}

function fileutile() {
  tmpname=$(mktemp)
  if fileutil test -f $1; then
    fileutil cat $1 > $tmpname
    $EDITOR $tmpname
    fileutil cp -f $tmpname $1
    rm $tmpname
  else
    $EDITOR $tmpname
    fileutil cp -f $tmpname $1
    rm $tmpname
  fi
}

function google3_footsteps() {
  if [[ $DIR_HISTFILE != '' ]]; then
    cat $DIR_HISTFILE | grep '/google/src/cloud/[a-z]*/[a-z_-]*/' \
      | sed 's:/google/src/cloud/[a-z]*/[a-z_-]*/google3/::' | sort -u
  fi
}

# edit after code search
function cse() {
  p4e $(cs $@)
}

# cd after code search
function csd() {
  g4cd $(cs $@)
}
