# local fish config

if test -e "$HOME/.config/fish/local.fish"
	source "$HOME/.config/fish/local.fish"
end

# global variables

set -gx EDITOR nvim
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git'
set -gx GIT_PAGER 'delta'
set -gx DESKTOP_SESSION 'gnome'
set -gx GPG_TTY (tty)
set -gx LANG en_US.UTF-8
set -gx LC_ALL C.UTF-8
set -gx NNN_PLUG 'd:dragdrop;z:autojump;G:getplugs;R:gitroot;r:renamer'
set -gx PROJECT_PATHS "$HOME/Projects"
set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx DOCKER_USER (id -u):(id -g)
set -gx DOCKER_HOST "unix://$XDG_RUNTIME_DIR/docker.sock"

if test -e '/opt/android-sdk'
  set -gx ANDROID_AVD_HOME '/opt/android-sdk/avd'
  set -gx ANDROID_SDK_ROOT '/opt/android-sdk'
  set -gx ANDROID_HOME '/opt/android-sdk'
  set -gx NDK_HOME "$ANDROID_HOME/ndk/$(ls -1 $ANDROID_HOME/ndk)"
  set -gx ANDROID_NDK_ROOT "$ANDROID_HOME/ndk/$(ls -1 $ANDROID_HOME/ndk)"
  fish_add_path $ANDROID_SDK_ROOT/cmdline-tools/latest/bin
end

if test -e '/usr/lib64/jvm/java'
  set -gx JAVA_HOME '/usr/lib64/jvm/java'
end

if test -e "$HOME/Applications/PlaydateSDK"
  set -gx PLAYDATE_SDK_PATH $HOME/Applications/PlaydateSDK
  fish_add_path $PLAYDATE_SDK_PATH/bin
end

if test -e "$HOME/.bun"
  set -gx BUN_INSTALL "$HOME/.bun"
end

# paths

fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.yarn/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/Applications
fish_add_path $HOME/AppImages
fish_add_path $HOME/Bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.spicetify
fish_add_path $BUN_INSTALL/bin
fish_add_path /opt/applications
fish_add_path /var/lib/flatpak/exports/bin

# abbreviations

abbr -a tst timew start
abbr -a ts timew summary
abbr -a tt timew tag
abbr -a tct timew continue @2

abbr -a gcl git clone

abbr -a m --set-cursor 'math "%"'

# project aliases

source $HOME/.config/fish/project_aliases.fish

# eww config

if type -q eww
  eww shell-completions --shell fish | source
end

# fnm

if type -q fnm
  fnm env --use-on-cd --log-level quiet | source
end

# ASDF golang

if test -e "$HOME/.asdf/plugins/golang/set-env.fish"
  source "$HOME/.asdf/plugins/golang/set-env.fish"
end

# fzf plugin config

fzf_configure_bindings --directory=\cf --git_log= --git_status= --history=\cr
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

