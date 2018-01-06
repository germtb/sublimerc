# Set path
export PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
export PATH='/Users/gmoreno/.npm-global/bin':$PATH
export PATH='/Users/gmoreno/bin':$PATH
# export PATH='/Users/gmoreno/.seon/bin':$PATH
export API_CLIENT_KEY=1022507da36a145a7421f28af3ee32eb

export TERM=xterm-256color
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh

# Add rouge manually to path
export PATH=${PATH}:'/Users/gmoreno/.gem/ruby/2.4.0/gems/rouge-2.2.1/bin'

# Set ZSH
export ZSH=~/.oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(git sublime npm osx sudo brew vi-mode)
source $ZSH/oh-my-zsh.sh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Prompt
export PROMPT='${ret_status} %{$fg[cyan]%}%~%{$reset_color%} $(git_prompt_info)'

# Set default editor
export VISUAL=nvim
export EDITOR=nvim

# Aliases
alias atom='atom .'
alias cat='rougify'
alias l='ls -la'
alias less='less -S -N'
alias o='cd ..'
alias vim='nvim'
# alias vim='/usr/local/bin/vim'

cd-ls() {
  cd $1
  ls -la
}
zle -N  cd-ls
alias cl='cd-ls'

# Git aliases
alias d='git diff'
alias s='git status'
alias ll='git log --name-status'
alias g-='git checkout -'
alias r-='git rebase -'
alias cc='git commit -m'
alias aa='git add --all && git status'
alias gg='git commit --amend --no-edit'
alias pp='git push -u origin HEAD'
alias pl='git pull'
alias rr='git reset --hard'
alias bb='git branch'

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_PREVIEW='[[ $(file --mime {}) =~ binary ]] &&
  echo {} is a binary file ||
  (highlight -O ansi -l {} || rougify {} || cat {}) 2> /dev/null | head -500'
export FZF_COMPLETION_TRIGGER='*'
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_COMPLETION_OPTS=' --extended --preview "[[ $(file --mime {}) =~ binary ]] &&
  echo {} is a binary file ||
  (highlight -O ansi -l {} || rougify {} || cat {}) 2> /dev/null | head -500"'

fzf-git-branch() {
  local branches branch
  branches=$(git branch) &&
  branch=$(echo "$branches" | fzf +m --height 40%) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
  zle reset-prompt
}
zle -N  fzf-git-branch
bindkey '^B' fzf-git-branch

fzf-git-remote-branch() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" | fzf +m --height 40%) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
  zle reset-prompt
}
zle -N  fzf-git-remote-branch
bindkey '^V' fzf-git-remote-branch

fzf-file() {
  local file=$(rg --files | fzf --height 40% --extended --preview $FZF_PREVIEW)
  if [[ -z "$file" ]]; then
    zle redisplay
    return 0
  fi
  </dev/tty vim "$file"
  zle reset-prompt
}
zle -N  fzf-file
bindkey '^P' fzf-file

fzf-dir() {
  local dir
	dir=$(find ${1:-~} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m --height 40% --preview "ls -la {}") &&
  cd "$dir"
  zle reset-prompt
}
zle -N  fzf-dir
bindkey '^O' fzf-dir

source ~/.secretrc

# Set edditing mode to vi
bindkey -v
KEYTIMEOUT=1
function zle-line-init zle-keymap-select {
    export RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
    export RPS2=$RPS1
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

bindkey -a u undo
bindkey -a U redo

# OPAM configuration
/Users/gmoreno/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

