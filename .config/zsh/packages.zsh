zplug "zplug/zplug", hook-build:'zplug --self-manage'
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"

zplug "lib/completion", from:oh-my-zsh
zplug "lib/git", from:oh-my-zsh

# --- Theme
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
# zplug "jackharrisonsherlock/common", , from:github, as:theme


zplug "agkozak/zsh-z"
