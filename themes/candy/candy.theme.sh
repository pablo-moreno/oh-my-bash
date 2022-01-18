#! bash oh-my-bash.module

function prompt_command() {
    PS1="${green}\u@\h $(clock_prompt) ${reset_color}${white}\w${reset_color}$(scm_prompt_info)${blue} →${bold_blue} ${reset_color} ";
}

THEME_CLOCK_COLOR=${THEME_CLOCK_COLOR:-"$blue"}
THEME_CLOCK_FORMAT=${THEME_CLOCK_FORMAT:-"%I:%M:%S"}

_omb_util_add_prompt_command prompt_command
