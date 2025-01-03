# Inspired by: https://nickjanetakis.com/blog/color-your-shell-prompt-red-if-the-last-command-threw-an-error
# Original theme: afowler
#
# Prompt format:        host :: cwd ‹git status› » ...
# The » and :: characters will change color (blue -> red) if the last command returns a non zero exit code
PROMPT='%m %B%(?.%F{blue}.%F{red}):: %f%b%F{green}%3~ $(git_prompt_info)%B%(?.%F{blue}.%F{red})»%f%b '
RPS1="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"
