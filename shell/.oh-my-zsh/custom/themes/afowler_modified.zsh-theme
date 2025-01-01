# Inspired by:
# https://github.com/beloglazov/oh-my-zsh/blob/master/themes/afowler.zsh-theme
# https://nickjanetakis.com/blog/color-your-shell-prompt-red-if-the-last-command-threw-an-error
# The » character will change color (blue -> red) if the last command returns a non zero exit code

PROMPT='%m %B%F{blue}:: %b%F{green}%3~ $(git_prompt_info)%B%(?.%F{blue}.%F{red})»%f%b '
RPS1="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"
