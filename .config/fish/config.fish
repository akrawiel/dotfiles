# paths

fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.yarn/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/Applications
fish_add_path $HOME/.local/bin
fish_add_path /opt/applications
fish_add_path /opt/android-sdk/platform-tools
fish_add_path /opt/android-sdk/tools
fish_add_path /opt/android-sdk/tools/bin

# global variables

set -gx ANDROID_SDK_ROOT '/opt/android-sdk'
set -gx EDITOR nvim
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git'
set -gx PROJECT_PATHS $HOME/Projects
set -gx GIT_PAGER 'delta'
set -gx GPG_TTY (tty)
set -gx NNN_PLUG 'z:autojump;G:getplugs;R:gitroot;r:renamer'
set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
set -gx XDG_CONFIG_HOME $HOME/.config

set -U FZF_COMPLETE 0

# options

set fish_greeting

function fish_user_key_bindings
    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert
end

set -g fish_cursor_default block
set -g fish_cursor_insert line
set -g fish_cursor_replace_one underscore
set -g fish_cursor_visual block

# custom booters

zoxide init fish | source

gpgconf --launch gpg-agent

if status is-interactive
    # Commands to run in interactive sessions can go here
end
