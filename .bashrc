#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -s autocd
shopt -s cdspell
shopt -s dirspell

alias vim='nvim'

alias diff='diff --color=auto'
alias ip='ip -color=auto'
export LESS='-R --use-color -Dd+r$Du+b'
alias grep='grep --color=auto'

alias webcam='mpv --demuxer-lavf-o=video_size=1920x1080,input_format=mjpeg av://v4l2:/dev/video0 --profile=low-latency --untimed'
alias xp="xprop | awk '/^WM_CLASS/{sub(/.* =/, \"instance:\"); sub(/,/, \"\nclass:\"); print}/^WM_NAME/{sub(/.* =/, \"title:\"); print}'"

alias gs='git status'
alias ga='git add'
alias gc='git commit'

alias nvcfg='nvim ~/.config/nvim/init.vim'

alias rpg-battle="rpg-cli cd -f . && rpg-cli battle"

alias rm="rpg-battle && rm"
alias rmdir="rpg-battle && rmdir"
alias mkdir="rpg-battle && mkdir"
alias touch="rpg-battle && touch"
alias mv="rpg-battle && mv"
alias cp="rpg-battle && cp"
alias chown="rpg-battle && chown"
alias chmod="rpg-battle && chmod"

alias la='ls -a'
alias ll='ls -la'

cd () {
    builtin cd "$@"
    command ls --color=auto
	if [[ $PWD == ~ ]] ; then
    	rpg-cli cd -f ~
	else
    	rpg-cli cd -f .
		rpg-cli battle
	fi
}

ls () {
    command ls --color=auto "$@"
    if [ $# -eq 0 ] ; then
        rpg-cli cd -f .
        rpg-cli ls 
    fi
}

PS1='[\u@\h \W]\$ '

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

complete -cf sudo
export PATH="$PATH:~/.local/bin"
export PATH="$HOME/.elan/bin:$PATH"
