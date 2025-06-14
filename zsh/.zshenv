# XDG directoryies
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DATA_DIRS="$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:/home/aidan/.local/share/flatpak/exports/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Theme
export GTK_THEME=Adwaita-dark:dark
export QT_STYLE_OVERRIDE=adwaita-dark
# export QT_QPA_PLATFORM=xcb

# Program specific overrides
export ZDOTDIR="${XDG_CONFIG_HOME}"/zsh
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
export NODE_REPL_HISTORY="$XDG_StATE_HOME"/node_repl_history
