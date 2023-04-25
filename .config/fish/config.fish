# paths

fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.yarn/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/Applications
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.spicetify
fish_add_path /opt/applications
fish_add_path /opt/android-sdk/platform-tools
fish_add_path /opt/android-sdk/tools
fish_add_path /opt/android-sdk/tools/bin

# global variables

set -gx ANDROID_SDK_ROOT '/opt/android-sdk'
set -gx EDITOR nvim
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git'
set -gx GIT_PAGER 'delta'
set -gx GPG_TTY (tty)
set -gx LANG en_US.UTF-8
set -gx LC_ALL C.UTF-8
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx NNN_PLUG 'd:dragdrop;z:autojump;G:getplugs;R:gitroot;r:renamer'
set -gx PROJECT_PATHS "$HOME/Projects"
set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
set -gx XDG_CONFIG_HOME $HOME/.config

# pyenv

set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin

pyenv init - | source

# abbreviations

abbr -a tst timew start
abbr -a ts timew summary
abbr -a tt timew tag
abbr -a tct timew continue @2

abbr -a gcl git clone

abbr -a s swallow

abbr -a L --position anywhere "| less"
abbr -a R --position anywhere "| rg"
abbr -a C --position anywhere "| xclip -selection clipboard"

abbr -a m --set-cursor 'math "%"'

# project aliases

source $HOME/.config/fish/project_aliases.fish

# fzf plugin config

fzf_configure_bindings --directory=\cf --git_log= --git_status= --history=\cr --variables=\cv --processes=\cp
set fzf_fd_opts --hidden --exclude=.git

function _open_with_editor
  set -l file (fzf --preview='bat --color always -pp {}');
  if test $file;
    $EDITOR $file;
  end;
end

function _open_with_xdg
  set -l file (fzf --preview='bat --color always -pp {}');
  if test $file;
    xdg-open $file;
  end;
end

bind --mode insert \co _open_with_editor
bind --mode insert \cx _open_with_xdg

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

setxkbmap pl -option caps:ctrl_modifier -option compose:sclk

zoxide init fish | source

gpgconf --launch gpg-agent

if status is-interactive
    # Commands to run in interactive sessions can go here
end
