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

alias nvcfg='nvim ~/.config/nvim/init.lua'



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

# ---- Color definitions ----
RESET='\[\e[m\]'

WHITE='\[\e[1;97m\]'
YELLOW='\[\e[0;93m\]'
CYAN='\[\e[0;36m\]'
ORANGE='\[\e[0;33m\]'
BLUE='\[\e[0;34m\]'
RED='\[\e[0;31m\]'

# ---- OSC133 support ----
# Command start marker (before each command)
PS0+='\e]133;C\e\\'

# Capture last exit status and send OSC 133 ;D
__pc_osc133() {
    LAST_STATUS=$?                     # store exit status natively
    printf '\e]133;D;%s\e\\' "$__LAST_STATUS"
}

# Prepend our function to PROMPT_COMMAND
if [[ ":$PROMPT_COMMAND:" != *":__pc_osc133:"* ]]; then
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }__pc_osc133
fi

# Dynamic PS1 using native variable
PS1="\[\e]133;A\a\]${WHITE}[${YELLOW}\u${CYAN}@${ORANGE}\h${WHITE}](${BLUE}\W${WHITE})]"\
'$(if (( LAST_STATUS == 0 )); then echo "'${ORANGE}\$${RESET}'"; else echo "'${RED}\$${RESET}'"; fi)'\
"\[\e]133;B\a\] "

# if command -v rpg-cli &> /dev/null
# then
# 
# 	PS1="\[\e]133;A\a\]${WHITE}[${YELLOW}\u${CYAN}@${ORANGE}\h${WHITE}](${BLUE}\W${WHITE})]\n"\
# 		'$(CLICOLOR_FORCE=1 rpg-cli stat -q 2>/dev/null | sed -r "s/@.*//" | sed "s/\\x1B\\[0m/\\x1B[0;97m/g" | sed -r "s/(\\x1B\\[[0-9;]{1,6}[mGK])/\\\\[\\1\\\\]/g")'\
# 		'$(if (( LAST_STATUS == 0 )); then echo "'${ORANGE}\$${RESET}'"; else echo "'${RED}\$${RESET}'"; fi)'\ 
# 		"\[\e]133;B\a\] " 
# 
# 	alias rpg-battle="rpg-cli cd -f . && rpg-cli battle"
# 
# 	alias rm="rpg-battle && rm"
# 	alias rmdir="rpg-battle && rmdir"
# 	alias mkdir="rpg-battle && mkdir"
# 	alias touch="rpg-battle && touch"
# 	alias mv="rpg-battle && mv"
# 	alias cp="rpg-battle && cp"
# 	alias chown="rpg-battle && chown"
# 	alias chmod="rpg-battle && chmod"
# 
# 	bcd () {
# 		builtin cd "$@"
# 		command ls --color=auto
# 		if [[ $PWD == ~ ]] ; then
# 			rpg-cli cd -f ~
# 		else
# 			rpg-cli cd -f . 
# 			rpg-cli battle --bribe
# 		fi
# 	}
# 	
# 	cd () {
# 		builtin cd "$@"
# 		command ls --color=auto
# 		if [[ $PWD == ~ ]] ; then
# 			rpg-cli cd -f ~
# 		else
# 			rpg-cli cd -f .
# 			rpg-cli battle
# 		fi
# 	}
# 
# 	ls () {
# 		command ls --color=auto "$@"
# 		if [ $# -eq 0 ] ; then
# 			rpg-cli cd -f .
# 			rpg-cli ls 
# 		fi
# 	}
# fi


bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

complete -cf sudo
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.elan/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
systemctl --user import-environment PATH

#case $TERM in
#    rxvt|*term|st*)
#        PROMPT_COMMAND='echo -ne "\033]0;$PWD\007"'
#    ;;
#esac

# Set up Node Version Manager
source /usr/share/nvm/init-nvm.sh
bind 'set completion-ignore-case on'
