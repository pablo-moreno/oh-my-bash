#! bash oh-my-bash.module

__tonka_time() {
  THEME_CLOCK_FORMAT="%H%M"
  clock_prompt
}

__tonka_date() {
  THEME_CLOCK_FORMAT="%a,%d %b %y"
  clock_prompt
}

__tonka_clock() {
  local LIGHT_BLUE="\[\033[1;34m\]"
  if [[ "${THEME_SHOW_CLOCK}" = "true" ]]; then
    echo "$(__tonka_time)${LIGHT_BLUE}:$(__tonka_date)${LIGHT_BLUE}:"
  fi
}

prompt_setter() {

#   Named "Tonka" because of the colour scheme
local WHITE="\[\033[1;37m\]"
local LIGHT_BLUE="\[\033[1;34m\]"
local YELLOW="\[\033[1;33m\]"
local NO_COLOUR="\[\033[0m\]"

case $TERM in
    xterm*|rxvt*)
        TITLEBAR='\[\033]0;\u@\h:\w\007\]'
        ;;
    *)
        TITLEBAR=""
        ;;
esac

PS1="$TITLEBAR\
$YELLOW-$LIGHT_BLUE-(\
$YELLOW\u$LIGHT_BLUE@$YELLOW\h\
$LIGHT_BLUE)-(\
$YELLOW\$PWD\
$LIGHT_BLUE)-$YELLOW-\
\n\
$YELLOW-$LIGHT_BLUE-(\
$(__tonka_clock)\
$WHITE\$ $LIGHT_BLUE)-$YELLOW-$NO_COLOUR "

PS2="$LIGHT_BLUE-$YELLOW-$YELLOW-$NO_COLOUR "

}

_omb_util_add_prompt_command prompt_setter

THEME_SHOW_CLOCK=${THEME_SHOW_CLOCK:-"true"}
THEME_CLOCK_COLOR=${THEME_CLOCK_COLOR:-"\[\033[1;33m\]"}

export PS3=">> "

LS_COLORS='no=00:fi=00:di=00;33:ln=01;36:pi=40;34:so=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.deb=01;31:*.jpg=01;35:*.gif=01;35:*.bmp=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.mpg=01;37:*.avi=01;37:*.gl=01;37:*.dl=01;37:';

export LS_COLORS
