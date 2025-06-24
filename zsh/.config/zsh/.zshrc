#
# ~/.zshrc
#
export GTK_THEME=Adwaita-dark:dark
export QT_STYLE_OVERRIDE=adwaita-dark
# export QT_QPA_PLATFORM=xcb
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DATA_DIRS="$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:/home/aidan/.local/share/flatpak/exports/share"
export XDG_STATE_HOME="$HOME/.local/state"
export CARGO_HOME="$XDG_DATA_HOME"/cargo 
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export NPM_CONFIG_INIT_MODULE="$XDG_CONFIG_HOME"/npm/config/npm-init.js       
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME"/npm                                 
export NPM_CONFIG_TMP="$XDG_RUNTIME_DIR"/npm
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/pythonrc
export STACK_ROOT="$XDG_DATA_HOME"/stack
export STACK_XDG=1
export WINEPREFIX="$XDG_DATA_HOME"/wine
export NODE_REPL_HISTORY="$XDG_STATE_HOME"/node_repl_historyi

export HISTFILE=~/.history
export HISTSIZE=10000
export SAVEHIST=10000
setopt appendhistory

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export EDITOR="nvim"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -alF'
alias nv='nvim'
alias neofetch='fastfetch'
alias icat="kitten icat"
alias vizsh="${EDITOR} ~/.config/zsh/.zshrc && source ~/.config/zsh/.zshrc"
alias vihypr="${EDITOR} ~/.config/hypr/hyprland.conf"
alias vihypr="${EDITOR} ~/.config/hypr/hyprland.conf"
alias vinv="${EDITOR} ~/.config/nvim/init.lua"
alias grep='grep --color=auto'

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

export PS1='[%n@%m %1~]$ '

PATH="$PATH:$HOME/.local/bin"

ZSH_AUTOSUGGEST_MANUAL_REBIND=1

source $ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZDOTDIR/zsh-autosuggestions/zsh-autosuggestions.zsh
