# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
# force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

red='\[\e[0;31m\]'
RED='\[\e[1;31m\]'
blue='\[\e[0;34m\]'
BLUE='\[\e[1;34m\]'
cyan='\[\e[0;36m\]'
CYAN='\[\e[1;36m\]'
green='\[\e[0;32m\]'
GREEN='\[\e[1;32m\]'
yellow='\[\e[0;33m\]'
YELLOW='\[\e[1;33m\]'
PURPLE='\[\e[1;35m\]'
purple='\[\e[0;35m\]'
nc='\[\e[0m\]'

if [ "$UID" = 0 ]; then
    PS1="$red\u$nc@$red\H$nc:$CYAN\w$nc\\n$red#$nc "
else
    PS1="$PURPLE\u$nc@$CYAN\H$nc:$GREEN\w$nc\\n$GREEN\$$nc "
fi
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -lh'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Default parameter to send to the "less" command
# -R: show ANSI colors correctly; -i: case insensitive search
LESS="-R -i"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Add sbin directories to PATH.  This is useful on systems that have sudo
echo $PATH | grep -Eq "(^|:)/sbin(:|)"     || PATH=$PATH:/sbin
echo $PATH | grep -Eq "(^|:)/usr/sbin(:|)" || PATH=$PATH:/usr/sbin

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

#Avoid org.a11y.Bus error essages without installing at-spi2-core
export NO_AT_BRIDGE=1

# startx as user for all antiX 'desktop' options alias
alias srj="startx /usr/local/bin/desktop-session rox-jwm"
alias srf="startx /usr/local/bin/desktop-session rox-fluxbox"
alias sri="startx /usr/local/bin/desktop-session rox-icewm"
alias szj="startx /usr/local/bin/desktop-session zzz-jwm"
alias szf="startx /usr/local/bin/desktop-session zzz-fluxbox"
alias szi="startx /usr/local/bin/desktop-session zzz-icewm"
alias smj="startx /usr/local/bin/desktop-session min-jwm"
alias smf="startx /usr/local/bin/desktop-session min-fluxbox"
alias smi="startx /usr/local/bin/desktop-session min-icewm"
alias shw="startx /usr/local/bin/desktop-session herbstluftwm"

#stop more than one instance of volumeicon running:
alias volumeicon="pidof volumeicon || volumeicon &"
alias dotsync='cd ~/system/dotfiles && git add . && git commit -m "Auto-update configurations: $(date +"%Y-%m-%d %H:%M")" && git push'
# Custom zero-bloat git synchronization command
alias dotsync="cd ~/system/dotfiles && git add . && git commit -m 'Auto-update' && git push"

# Enable native vim mode and mode strings
set -o vi
bind 'set show-mode-in-prompt on'
bind 'set vi-ins-mode-string "\1\e[32;1m\2[INS]\1\e[0m\2 "'
bind 'set vi-cmd-mode-string "\1\e[33;1m\2[NOR]\1\e[0m\2 "'

# Clean, professional colored prompt (Blue username, Cyan folder path)
PS1='\[\e[34;1m\]\u@\h\[\e[0m\]:\[\e[36;1m\]\w\[\e[0m\]\$ '

source /usr/share/doc/fzf/examples/key-bindings.bash



bat-time() {
    echo "Monitoring battery drain... (Please wait 20 seconds)"
    C1=$(cat /sys/class/power_supply/BAT1/charge_now)
    sleep 20
    C2=$(cat /sys/class/power_supply/BAT1/charge_now)
    
    DROP=$((C1 - C2))
    
    if [ $DROP -gt 0 ]; then
        # Calculates consumption over the 20-second window
        RATE=$((DROP / 20))
        REM_SEC=$((C2 / RATE))
        HOURS=$((REM_SEC / 3600))
        MINS=$(((REM_SEC % 3600) / 60))
        PCT=$(cat /sys/class/power_supply/BAT1/capacity)
        echo "======================================"
        echo " Battery Status: $PCT%"
        echo " Time Remaining: ${HOURS}h ${MINS}m"
        echo "======================================"
    elif [ "$(cat /sys/class/power_supply/BAT1/status)" = "Charging" ]; then
        echo "The battery is currently charging on AC power."
    else
        echo "No power drop detected in 20 seconds. Try running a heavier application and test again."
    fi
}
