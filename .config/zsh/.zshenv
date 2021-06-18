# ---------------------------------------------------------------------------------------
# ---{ My ~/.zshenv } -------------------------------------------------------------------
# ---------------------------------------------------------------------------------------
#
#   Unlike the ~/.zprofile, this file is sourced often, and it's a good place to put
#   variables that are subject to change throughout the session such as the PATH
#
#   By setting it in that file, reopening a terminal emulator will start a new Zsh
#   instance with the PATH value updated.

function check_for_command(){ command -v $1 >/dev/null 2>&1 }


# ---{ XDG Compliance}-------------------------------------------------------------------

# Set XDG Base Directory
export XDG_LOCAL_HOME="$HOME/.local"
export XDG_DATA_HOME="$XDG_LOCAL_HOME/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

if check_for_command nvm
then
    export NVM_DIR="$HOME/.nvm" # You probably have this line already
    export NODE_VERSIONS="${NVM_DIR}/versions/node"
    export NODE_VERSION_PREFIX="v"
fi

if check_for_command gpg
then export GPG_TTY=$(tty)
fi

if check_for_command kitty
then export TERMINAL="kitty"
fi

function PATH_append(){
    if [[ -e $1 ]] && [[ ":$PATH:" != *":$1:"* ]]
    then PATH="$1:$PATH"
    fi
}

export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/Brewfile"      
HOMEBREW_PREFIX="/usr/local/opt"

PATH_append "$HOME/programs/google-cloud-sdk/bin"
PATH_append "$HOMEBREW_PREFIX/helm@2/bin"
PATH_append "$HOMEBREW_PREFIX/node@12/bin"
PATH_append "$HOME/.emacs.d/bin"
# PATH_append "$HOME/programs/nvim-osx64/bin"

export PATH
