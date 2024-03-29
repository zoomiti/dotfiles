#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -s autocd
shopt -s cdspell
shopt -s dirspell

alias nv='nvim'

alias diff='diff --color=auto'
alias ip='ip -color=auto'
export LESS='-R --use-color -Dd+r$Du+b'
alias grep='grep --color=auto'

alias webcam='mpv --demuxer-lavf-o=video_size=1920x1080,input_format=mjpeg av://v4l2:/dev/video0 --profile=low-latency --untimed'
alias xp="xprop | awk '/^WM_CLASS/{sub(/.* =/, \"instance:\"); sub(/,/, \"\nclass:\"); print}/^WM_NAME/{sub(/.* =/, \"title:\"); print}'"
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git pull'
alias gP='git push'

alias nvcfg='nvim ~/.config/nvim/init.vim'



alias la='ls -a'
alias ll='ls -la'

alias vifm='vifmrun'


vicd () {
	dst="$(command vifm --choose-dir - . "$@")"
	if [ -z "$dst" ] ; then
		echo 'Directory picking cancelled/failed'
	fi
	cd "$dst"
}

if command -v rpg-cli &> /dev/null
then
	PS1='\[\e[1;97m\][\[\e[0;93m\]\u\[\e[0;36m\]@\[\e[0;33m\]\h\[\e[1;97m\]](\[\e[0;34m\]\W\[\e[1;97m\])\n$(CLICOLOR_FORCE=1 rpg-cli stat -q | sed -r "s/@.*//" | sed "s/\\x1b\\[0m/\x1b[0;97m/g" | sed -r "s/(\\x1B\\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK])/\[\1\]/g" )\[\e[0;33m\]\$\[\e[m\] '
	alias rpg-battle="rpg-cli cd -f . && rpg-cli battle"

	alias rm="rpg-battle && rm"
	alias rmdir="rpg-battle && rmdir"
	alias mkdir="rpg-battle && mkdir"
	alias touch="rpg-battle && touch"
	alias mv="rpg-battle && mv"
	alias cp="rpg-battle && cp"
	alias chown="rpg-battle && chown"
	alias chmod="rpg-battle && chmod"

	bcd () {
		builtin cd "$@"
		command ls --color=auto
		if [[ $PWD == ~ ]] ; then
			rpg-cli cd -f ~
		else
			rpg-cli cd -f . 
			rpg-cli battle --bribe
		fi
	}
	
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
else
	PS1='[\u@\h \W]\$ '
fi


bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

complete -cf sudo
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.elan/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

#case $TERM in
#    rxvt|*term|st*)
#        PROMPT_COMMAND='echo -ne "\033]0;$PWD\007"'
#    ;;
#esac

# Set up Node Version Manager
source /usr/share/nvm/init-nvm.sh
bind 'set completion-ignore-case on'
