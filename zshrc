if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ ! -a ~/.oh-my-zsh ]]; then
  git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi
export ZSH="$HOME/.oh-my-zsh"
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
export SERGE_DATABASE="DBI:SQLite:dbname=$HOME/.serge/db/intellum.db3"
export SERGE_DATA_DIR="$HOME/.serge"
export PATH="$PATH:$HOME/.serge/serge/bin/:$HOME/bin:$HOME/.serverless/bin:$PATH"


if [[ -r /usr/local/opt/python/libexec ]]; then
  export PATH="/usr/local/opt/python/libexec/bin:$PATH"
fi

ZSH_THEME=powerlevel10k/powerlevel10k
source $HOME/.oh-my-zsh/oh-my-zsh.sh

for function in ~/.zsh/functions/*; do
  source $function
done



# extra files in ~/.zsh/configs/pre , ~/.zsh/configs , and ~/.zsh/configs/post
# these are loaded first, second, and third, respectively.
_load_settings() {
  _dir="$1"
  if [ -d "$_dir" ]; then
    if [ -d "$_dir/pre" ]; then
      for config in "$_dir"/pre/**/*(N-.); do
        if [ ${config:e} = "zwc" ] ; then continue ; fi
        . $config
      done
    fi

    for config in "$_dir"/**/*(N-.); do
      case "$config" in
        "$_dir"/pre/*)
          :
          ;;
        "$_dir"/post/*)
          :
          ;;
        *)
          if [[ -f $config && ${config:e} != "zwc" ]]; then
            . $config
          fi
          ;;
      esac
    done

    if [ -d "$_dir/post" ]; then
      for config in "$_dir"/post/**/*(N-.); do
        if [ ${config:e} = "zwc" ] ; then continue ; fi
        . $config
      done
    fi
  fi
}
# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases
source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
_load_settings "$HOME/.zsh/configs"
alias sock='export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock'
alias ptest='RAILS_ENV=test rake parallel:migrate && rake parallel:test'
alias burnpack='bundle install && yarn install && webpack && RAILS_ENV=test bundle exec webpack'
alias be='bundle exec'

plugins=(
  asdf
  git
  bundler
  dotenv
  osx
  rake
  ruby
  zsh-autosuggestions
)

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
alias myip='curl ifconfig.co/'


# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true
eval $(thefuck --alias)
alias node_cli='node -i -e "$(< ./cli.js )"'

# bun completions
[ -s "/Users/mtuckerb/.bun/_bun" ] && source "/Users/mtuckerb/.bun/_bun"

# bun
export BUN_INSTALL="/Users/mtuckerb/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/mtuckerb/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/mtuckerb/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/mtuckerb/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/mtuckerb/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

