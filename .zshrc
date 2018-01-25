# Path to your oh-my-zsh installation.
export ZSH=/Users/tmorozov/.oh-my-zsh
export WORKON_HOME=/Volumes/Data/Envs

source /usr/local/bin/virtualenvwrapper.sh
# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.

#ZSH_THEME="robbyrussell"
ZSH_THEME="powerline"
POWERLINE_HIDE_HOST_NAME="true"
POWERLINE_DISABLE_RPROMPT="true"
POWERLINE_DETECT_SSH="true"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Volumes/Data/Downloads/biicode"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
hash -d prj=/Volumes/Data/Project
hash -d ydx=/Volumes/Data/YDisk/Yandex.Disk.localized
# Uncomment following line if you want red dots to be displayed while waiting for completion
#COMPLETION_WAITING_DOTS="true"

if [[ -z ${MY_SHELL_LEVEL} ]]; then
  export MY_SHELL_LEVEL=0
else
  export MY_SHELL_LEVEL=$(($MY_SHELL_LEVEL+1))
fi

export SS_DISPLAY_LIMIT=25
export ZSH_CUSTOM=~/.dotfiles/zsh_custom
plugins=(git regex-dirstack)
source $ZSH/oh-my-zsh.sh
#source $ZSH_CUSTOM/themes/gnzh.zsh-theme

#bindkey -v
bindkey -M viins 'jj' vi-cmd-mode
setopt auto_pushd
setopt pushd_silent
setopt pushd_ignore_dups
setopt ignore_eof
setopt rm_star_silent
unsetopt nomatch
unsetopt correct_all

if [ $(uname) = Darwin ]; then
  export PATH=.:~/bin:~/local/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/Volumes/Data/Downloads/biicode
else
  alias open=gnome-open
  export PATH=.:buildutil:~/bin:~/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
fi

export GPGKEY=B2F6D883
export GPG_TTY=$(tty)

export SBT_OPTS=-XX:PermSize=256M

if which dircolors > /dev/null; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto -F'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

function eecho
{
  echo $@ 1>&2
}

function findWithSpec
{
  local dirs=
  local egrepopts="-v '\\.sw[po]\\$|/\\.git/|^\\.git/|/\\.svn/|^\\.svn/'"
  local nullprint=
  while [[ $# != 0 ]];
  do
    if [[ "$1" == "-Z" ]]; then
      egrepopts="-Zz $egrepopts"
      nullprint="-print0"
      shift
    elif [[ -d "$1" ]]; then
      dirs="$dirs '$1'"
      shift
    else
      break
    fi
  done
  if [[ -z "$dirs" ]]; then
    dirs=.
  fi
  eval "find $dirs $nullprint $@ | egrep $egrepopts"
}

function findsrc
{
  findWithSpec "$@" '-name \*.java -o -name \*.scala -o -name Makefile -o -name \*.h -o -name \*.cpp -o -name \*.c'
}
alias findsrcz="findsrc -Z"

function findj
{
  findWithSpec "$@" '-name \*.java'
}
alias findjz="findj -Z"

function finds
{
  findWithSpec "$@" '-name \*.scala'
}
alias findsz="finds -Z"

function findsj
{
  (finds "$@"; findj "$@")
}
alias findsjz="findsj -Z"

function findh
{
  findWithSpec "$@" '-name \*.h -o -name \*.hpp'
}
alias findhz="findh -Z"

function findc
{
  findWithSpec "$@" '-name \*.cpp -o -name \*.c'
}
alias findcz="findc -Z"

function findch
{
  (findc "$@"; findh "$@")
}
alias findchz="findch -Z"

function findpy
{
  findWithSpec "$@" '-name \*.py'
}
alias findcpy="findpy -Z"

function findf
{
  findWithSpec "$@" "-type f"
}
alias findfz="findf -Z"

function findm
{
  findWithSpec "$@" "-name Makefile"
}
alias findmz="findm -Z"

function findpom
{
  findWithSpec "$@" "-name pom.xml"
}
alias findpomz="findpom -Z"

function findx
{
  findWithSpec "$@" "-name \*.xml"
}
alias findxz="findx -Z"

function findd
{
  findWithSpec "$@" "-type d"
}
alias finddz="findd -Z"

function findExtension
{
  local ext=
  local dir=.
  if [[ $# == 0 ]]; then
    echo "usage: findExtension [dir] <extension>"
    return 1
  else
    ext=$@[$#]
    if [[ $# != 1 ]]; then
      dir=$1
    fi
  fi
  findWithSpec $dir '-name \*'.$ext
}

alias fe=findExtension
alias f=findWithSpec
alias fn='find . -name'

function findClass
{
  local pattern="${1-}"
  if [ -z "$pattern" ]; then
    eecho "No pattern supplied" 1>&2
    return 1
  fi
  echo $CLASSPATH | tr ':' '\n' | grep -v '^ *$' | \
    while read entry
    do
      echo "====== $entry ======"
      if [ "${entry%.jar}" != "$entry" ]; then
        if [ -f "$entry" ]; then
          jar tf "$entry" | egrep $pattern
        fi
      elif [ -d "$entry" ]; then
        find "$entry" | egrep -i $pattern
      fi
    done
}

function ff
{
  if [ $# = 0 ]; then
    eecho "usage: ff <file>" 1>&2
    return 1
  fi
  if [ -d "$1" ]; then
    eecho "That's a directory, dumbass." 1>&2
    return 1
  elif [ "${1%/*}" = "$1" ]; then
    firefox -new-tab "file://$(pwd)/$1"
  else
    "cd" "${1%/*}"
    local dir="$(pwd)"
    "cd" - >/dev/null
    firefox -new-tab "file://$dir/${1##*/}"
  fi
  return 0
}

function gitall
{
  find . -type d -a -name .git | while read d
  do
    local x=${d%.git}
    echo ========= $x
    (cd $x; git "$@")
  done
}

# Assorted
alias swps='find . -name .\*.sw[op]'
alias rmstd='xargs rm -vf'
alias xag='xargs -0 egrep'
alias xg='xargs egrep'
alias xgi='xargs egrep -i'
alias pd="cd -"
alias grss='for f in $(find . -type d -a -name .git); do x=${f%/.git}; echo ==== $x; (cd $x; gss); done'
alias o=octave

# Formatting constants
export BOLD=`tput bold`
export UNDERLINE_ON=`tput smul`
export UNDERLINE_OFF=`tput rmul`
export TEXT_BLACK=`tput setaf 0`
export TEXT_RED=`tput setaf 1`
export TEXT_GREEN=`tput setaf 2`
export TEXT_YELLOW=`tput setaf 3`
export TEXT_BLUE=`tput setaf 4`
export TEXT_MAGENTA=`tput setaf 5`
export TEXT_CYAN=`tput setaf 6`
export TEXT_WHITE=`tput setaf 7`
export BACKGROUND_BLACK=`tput setab 0`
export BACKGROUND_RED=`tput setab 1`
export BACKGROUND_GREEN=`tput setab 2`
export BACKGROUND_YELLOW=`tput setab 3`
export BACKGROUND_BLUE=`tput setab 4`
export BACKGROUND_MAGENTA=`tput setab 5`
export BACKGROUND_CYAN=`tput setab 6`
export BACKGROUND_WHITE=`tput setab 7`
export RESET_FORMATTING=`tput sgr0`
  
# Wrapper function for Maven's mvn command.
#mvn-colour()
#{
#  # Filter mvn output using sed
#    exec mvn $@ | sed \
#        a
#        -e "s/\(\[INFO\]\ \-.*\)/${TEXT_BLUE}${BOLD}\1${RESET_FORMATTING}/g" \
#        -e "s/\(\[INFO\]\ \[.*\)/${RESET_FORMATTING}${BOLD}\1${RESET_FORMATTING}/g" \
#        -e "s/\(\[INFO\]\ BUILD SUCCESS\)/${BOLD}${TEXT_GREEN}\1${RESET_FORMATTING}/g" \
#        -e "s/\(\[WARNING\].*\)/${BOLD}${TEXT_YELLOW}\1${RESET_FORMATTING}/g" \
#        -e "s/\(\[ERROR\].*\)/${BOLD}${TEXT_RED}\1${RESET_FORMATTING}/g" \
#        -e "s/Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/${BOLD}${TEXT_GREEN}Tests run: \1${RESET_FORMATTING}, Failures: ${BOLD}${TEXT_RED}\2${RESET_FORMATTING}, Errors: ${BOLD}${TEXT_RED}\3${RESET_FORMATTING}, Skipped: ${BOLD}${TEXT_YELLOW}\4${RESET_FORMATTING}/g"
#        # Make sure formatting is reset
#    echo -ne ${RESET_FORMATTING}
#}

#alias mvn=~/bin/mvn-colour
#alias mvn="mvn-colour"

alias gl='git pull --ff-only'
alias gf='git fetch'
alias gd='git diff'
alias gdc='git diff --cached'

alias gld="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"

alias sc=screen
alias scl="screen -list"

alias pgrep="pgrep -fl"

alias bc="bc -lq"

test -f ~/.zshrc_local && . ~/.zshrc_local

# Auvik Settings
export JAVA_OPTS="-XX:ReservedCodeCacheSize=128m -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=1024m -Xmx1024m -Xss2m -XX:+UseCodeCacheFlushing"


alias icmakepp='cmake -P /Volumes/Data/Tools/cmakepp/cmakepp.cmake icmake'
alias cmakepp='cmake -P /Volumes/Data/Tools/cmakepp/cmakepp.cmake'
alias pkg='cmake -P /Volumes/Data/Tools/cmakepp/cmakepp.cmake cmakepp_project_cli'
alias cml='cmake -P /Volumes/Data/Tools/cmakepp/cmakepp.cmake cmakelists_cli'
export CMAKEPP_PATH=/Volumes/Data/Tools/cmakepp/cmakepp.cmake


export MGOPATH=/Volumes/Data/.mgopath

# The next line updates PATH for the Google Cloud SDK.
if [ -f /Volumes/Data/Tools/google-cloud-sdk/path.zsh.inc ]; then
  source '/Volumes/Data/Tools/google-cloud-sdk/path.zsh.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f /Volumes/Data/Tools/google-cloud-sdk/completion.zsh.inc ]; then
  source '/Volumes/Data/Tools/google-cloud-sdk/completion.zsh.inc'
fi

### Added by the Bluemix CLI
source /usr/local/Bluemix/bx/zsh_autocomplete
