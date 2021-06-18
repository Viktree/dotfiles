# ---------------------------------------------------------------------------------------
# ---{ My ~/.zprofile } -----------------------------------------------------------------
# ---------------------------------------------------------------------------------------
#
#   The file ~/.profile is loaded by login shells. The login shell is the first process
#   that is started when you log in in text mode, for example on a text console or via
#   ssh. It serves the same function as the ~/.bash_profile, serves when the default
#   shell is bash except that the default shell is zsh.
#
#   Typically, ~/.profile contains environment variable definitions, and might start some
#   programs that you want to run once when you log in or for the whole session.
#
#   Variables that are more prone to change, like $PATH declared in .zshenv
#
# ---{ Pre-load Checks }-----------------------------------------------------------------
#
#   -e    exit on first error
#   -u    exit when an undefined variable
#   -o    pipefail exit when any cmd in pipe sequence has exitcode != 0
#   -x    print all commands
#

set -euo pipefail

# ---{ Utility Functions }---------------------------------------------------------------

function check_for_command(){ command -v $1 >/dev/null 2>&1 }
function source_if_file(){ [[ -f $1 ]] && source $1 }
function source_if_possible(){ [[ -e $1 ]] && source $1 }

# ---{ OS Setiings }---------------------------------------------------------------------
#
#   Set some operating system specific stuff

PLATFORM='unknown'
case "$(uname)" in
    "Darwin") PLATFORM='osx';;
    "Linux") PLATFORM='linux';;
    "FreeBSD") PLATFORM='freebsd';;
    *);;
esac

export DEFAULT_USER=`whoami`
export LANG="en_US.UTF-8"
# export SSH_KEY_PATH="~/.ssh/rsa_id"

function is_mac(){ [[ "$PLATFORM" == "osx" ]]  }
function is_linux(){ [[ "$PLATFORM" == "linux" ]]  }
function is_freebsd(){ [[ "$PLATFORM" == "freebsd" ]]  }
function is_windows(){ grep -q Microsoft /proc/version }

if check_for_command git
then
    alias g="git"
    if check_for_command diff-so-fancy
    then
        git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
    fi

    # Save git password
    if is_mac
    then
        git config --global credential.helper osxkeychain
    else
        git config --global credential.helper cache
    fi

    git config --global core.excludesfile "$HOME/.config/git/ignore"
    git config --global commit.template   "$HOME/.config/git/commit-template"

    git config --global alias.switch-branch checkout
    git config --global alias.c commit
    git config --global alias.ls "status -s"
fi

# List the iPhone simulator as an application
if [[ -f "/Applications/Xcode.app/Contents/Applications/iPhone\ Simulator.app"  ]]
then
    ln -s "/Applications/Xcode.app/Contents/Applications/iPhone\ Simulator.app /Applications"
fi

# ---{ PROGRAMS }------------------------------------------------------------------------

if [[ -e '/usr/local/bin/code' ]]
then
    export EDITOR='/usr/local/bin/code'
fi

export NVM_AUTO_USE=true
if [[ -e '$HOME/.nvm/usr/local/opt/nvm/nvm.sh' ]]
then
    export NVM_DIR="$HOME/.nvm/usr/local/opt/nvm/nvm.sh"
fi

# ---{ Post-load Checks }----------------------------------------------------------------
#
#   -e    exit on first error
#   -u    exit when an undefined variable
#   -o    pipefail exit when any cmd in pipe sequence has exitcode != 0
#   -x    print all commands
#

set +euo pipefail

# ---------------------------------------------------------------------------------------

