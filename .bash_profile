#
# ~/.bash_profile
#

export TERMINAL="alacritty"
export EDITOR="nvim"

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then exec startx; fi
