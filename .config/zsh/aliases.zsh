#!/bin/zsh

function check_for_command(){ command -v $1 >/dev/null 2>&1 }

alias ..="cd .."

if check_for_command kubectl
then
    alias connect2db="kubectl port-forward deployment/cloudsql-proxy -n infra 5432:5432"
fi

if check_for_command exa
then alias ls="exa"
fi


if check_for_command bat
then alias cat='bat --paging=never --style=plain'
fi

function hsPortForward(){
    kubectx hs-$1
    connect2db
}

if check_for_command git
then
    alias gls="git status -s"
    alias gnb="git checkout -b"

    if check_for_command fzf
    then alias gsb='git checkout $(git branch | fzf)'
    fi
    
fi


