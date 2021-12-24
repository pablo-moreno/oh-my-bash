#!/usr/bin/env bash

# Bail out early if non-interactive
case $- in
  *i*) ;;
    *) return;;
esac

# Check for updates on initial load...
if [ "$DISABLE_AUTO_UPDATE" != "true" ]; then
  env OMB=$OMB DISABLE_UPDATE_PROMPT=$DISABLE_UPDATE_PROMPT bash -f $OMB/tools/check_for_upgrade.bash
fi

# Initializes Oh My Bash

# add a function path
fpath=($OMB/functions $fpath)

# Set OMB_CUSTOM to the path where your custom config files
# and plugins exists, or else we will use the default custom/
if [[ -z "$OMB_CUSTOM" ]]; then
    OMB_CUSTOM="$OMB/custom"
fi

# Set OMB_CACHE_DIR to the path where cache files should be created
# or else we will use the default cache/
if [[ -z "$OMB_CACHE_DIR" ]]; then
  OMB_CACHE_DIR="$OMB/cache"
fi

# Load all of the config files in ~/.oh-my-bash/lib that end in .bash
# TIP: Add files you don't want in git to .gitignore
for config_file in $OMB/lib/*.bash; do
  custom_config_file="${OMB_CUSTOM}/lib/${config_file:t}"
  [ -f "${custom_config_file}" ] && config_file=${custom_config_file}
  source $config_file
done


is_plugin() {
  local base_dir=$1
  local name=$2
  test -f $base_dir/plugins/$name/$name.plugin.bash \
    || test -f $base_dir/plugins/$name/_$name
}
# Add all defined plugins to fpath. This must be done
# before running compinit.
for plugin in ${plugins[@]}; do
  if is_plugin $OMB_CUSTOM $plugin; then
    fpath=($OMB_CUSTOM/plugins/$plugin $fpath)
  elif is_plugin $OMB $plugin; then
    fpath=($OMB/plugins/$plugin $fpath)
  fi
done

is_completion() {
  local base_dir=$1
  local name=$2
  test -f $base_dir/completions/$name/$name.completion.bash
}
# Add all defined completions to fpath. This must be done
# before running compinit.
for completion in ${completions[@]}; do
  if is_completion $OMB_CUSTOM $completion; then
    fpath=($OMB_CUSTOM/completions/$completion $fpath)
  elif is_completion $OMB $completion; then
    fpath=($OMB/completions/$completion $fpath)
  fi
done

is_alias() {
  local base_dir=$1
  local name=$2
  test -f $base_dir/aliases/$name/$name.aliases.bash
}
# Add all defined completions to fpath. This must be done
# before running compinit.
for alias in ${aliases[@]}; do
  if is_alias $OMB_CUSTOM $alias; then
    fpath=($OMB_CUSTOM/aliases/$alias $fpath)
  elif is_alias $OMB $alias; then
    fpath=($OMB/aliases/$alias $fpath)
  fi
done

# Figure out the SHORT hostname
if [[ "$OSTYPE" = darwin* ]]; then
  # macOS's $HOST changes with dhcp, etc. Use ComputerName if possible.
  SHORT_HOST=$(scutil --get ComputerName 2>/dev/null) || SHORT_HOST=${HOST/.*/}
else
  SHORT_HOST=${HOST/.*/}
fi

# Load all of the plugins that were defined in ~/.bashrc
for plugin in ${plugins[@]}; do
  if [ -f $OMB_CUSTOM/plugins/$plugin/$plugin.plugin.bash ]; then
    source $OMB_CUSTOM/plugins/$plugin/$plugin.plugin.bash
  elif [ -f $OMB/plugins/$plugin/$plugin.plugin.bash ]; then
    source $OMB/plugins/$plugin/$plugin.plugin.bash
  fi
done

# Load all of the aliases that were defined in ~/.bashrc
for alias in ${aliases[@]}; do
  if [ -f $OMB_CUSTOM/aliases/$alias.aliases.bash ]; then
    source $OMB_CUSTOM/aliases/$alias.aliases.bash
  elif [ -f $OMB/aliases/$alias.aliases.bash ]; then
    source $OMB/aliases/$alias.aliases.bash
  fi
done

# Load all of the completions that were defined in ~/.bashrc
for completion in ${completions[@]}; do
  if [ -f $OMB_CUSTOM/completions/$completion.completion.bash ]; then
    source $OMB_CUSTOM/completions/$completion.completion.bash
  elif [ -f $OMB/completions/$completion.completion.bash ]; then
    source $OMB/completions/$completion.completion.bash
  fi
done

# Load all of your custom configurations from custom/
for config_file in $OMB_CUSTOM/*.bash; do
  if [ -f $config_file ]; then
    source $config_file
  fi
done
unset config_file

# Load colors first so they can be use in base theme
source "${OMB}/themes/colours.theme.bash"
source "${OMB}/themes/base.theme.bash"

# Load the theme
if [ "$OMB_THEME" = "random" ]; then
  themes=($OMB/themes/*/*theme.bash)
  N=${#themes[@]}
  ((N=(RANDOM%N)))
  RANDOM_THEME=${themes[$N]}
  source "$RANDOM_THEME"
  echo "[oh-my-bash] Random theme '$RANDOM_THEME' loaded..."
else
  if [ ! "$OMB_THEME" = ""  ]; then
    if [ -f "$OMB_CUSTOM/$OMB_THEME/$OMB_THEME.theme.bash" ]; then
      source "$OMB_CUSTOM/$OMB_THEME/$OMB_THEME.theme.bash"
    elif [ -f "$OMB_CUSTOM/themes/$OMB_THEME/$OMB_THEME.theme.bash" ]; then
      source "$OMB_CUSTOM/themes/$OMB_THEME/$OMB_THEME.theme.bash"
    else
      source "$OMB/themes/$OMB_THEME/$OMB_THEME.theme.bash"
    fi
  fi
fi

if [[ $PROMPT ]]; then
    export PS1="\["$PROMPT"\]"
fi

if ! type_exists '__git_ps1' ; then
  source "$OMB/tools/git-prompt.bash"
fi

# Adding Support for other OSes
[ -s /usr/bin/gloobus-preview ] && PREVIEW="gloobus-preview" ||
[ -s /Applications/Preview.app ] && PREVIEW="/Applications/Preview.app" || PREVIEW="less"
