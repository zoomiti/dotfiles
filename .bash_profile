#
# ~/.bash_profile
#

export TERMINAL="st"
export EDITOR="nvim"

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then exec startx; fi
