#! bash oh-my-bash.module
SCM_THEME_PROMPT_DIRTY=" ${red}✗"
SCM_THEME_PROMPT_CLEAN=" ${bold_green}✓"
SCM_THEME_PROMPT_PREFIX=" |"
SCM_THEME_PROMPT_SUFFIX="${green}|"

GIT_THEME_PROMPT_DIRTY=" ${red}✗"
GIT_THEME_PROMPT_CLEAN=" ${bold_green}✓"
GIT_THEME_PROMPT_PREFIX=" ${green}|"
GIT_THEME_PROMPT_SUFFIX="${green}|"

# Nicely formatted terminal prompt
function prompt_command(){
  export PS1="\n${bold_black}[${blue}\@${bold_black}]-${bold_black}[${green}\u${yellow}@${green}\h${bold_black}]-${bold_black}[${purple}\w${bold_black}]-$(scm_prompt_info)\n${reset_color}\$ "
}

_omb_util_add_prompt_command prompt_command
