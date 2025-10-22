set -xg EDITOR $HOME/git/dot/bin/v
set -xg PATH $PATH $HOME/bin
set -xg PATH $PATH $HOME/.local/bin
set -xg PATH $HOME/dev/dot/bin $PATH ^/dev/null
set -xg PATH $HOME/git/dot/bin $PATH ^/dev/null
set -xg PATH $PATH /data1/zwinkau/intellij-idea/bin ^/dev/null
set -xg PATH $PATH $HOME/.cargo/bin

set -xg JAVA_HOME /usr/lib/jvm/default-java

set -xg LANG "en_US.utf8"
set -xg LANGUAGE "$LANG"
set -xg LC_ALL "$LANG"
set -xg LC_MONETARY "de_DE.utf8"
set -xg LC_MEASUREMENT "de_DE.utf8"
set -xg LC_NUMERIC "de_DE.utf8"
set -xg LC_TIME "de_AT.utf8" # austria has better date formatting

set -xg HOSTNAME (hostname)

if test -f ~/.nix-profile/etc/profile.d/nix.sh
    # replicate ~/.nix-profile/etc/profile.d/nix.sh for fish
    # no setup stuff, so you should run it with bash once
    set -xg NIX_PATH ~/.nix-defexpr/channels/nixpkgs
    set -xg NIX_SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
    set -xg PATH $PATH ~/.nix-profile/bin
    echo "Nix is available"
end

if status --is-login
    echo "Login Shell!"
end

function git_prompt -d "short info about git repos if available"
    if git status >/dev/null ^/dev/null
        set -l branch (git name-rev HEAD --name-only --always ^/dev/null)
        echo -n "[gb "$branch"]"
    end
end

function log_persistent_history --on-event fish_preexec
    set -l pershist $HOME/.history_persistent_$HOSTNAME
    set -l time (date --iso-8601=seconds)
    echo "$time $argv" >>$pershist
end

if begin set -q DISPLAY ;and test -e /usr/bin/xprop; end
  function preexec_test --on-event fish_preexec
      set -g preexec_time (date --iso-8601=seconds)
      set -g MY_WINDOW_ID (xprop -root _NET_ACTIVE_WINDOW)
  end

  function postexec_test --on-event fish_postexec
      set -l RET "$status"
      set -l postexec_time (date --iso-8601=seconds)
      set -l ACTIVE_WINDOW (xprop -root _NET_ACTIVE_WINDOW)
      if [ "$ACTIVE_WINDOW" != "$MY_WINDOW_ID" ]
          notify_long_running2.py "$preexec_time" "$postexec_time" "$argv" "$RET"
      end
  end
end

switch $HOSTNAME
case 'carbon'
  set PROMPT_COLOR green
case 'qznc.*'
  set PROMPT_COLOR red
case 'copacetic-*'
  set PROMPT_COLOR blue
case '*'
  set PROMPT_COLOR yellow
end

function fish_right_prompt -d "shown to the right of my prompt"
  set_color brown
  echo -n "done "
  echo -n (date "+%H:%M:%S")
  echo -n " in "
  prompt_pwd
end

function fish_prompt -d "Write out the prompt"
    set -l RET $status
    set_color red
    [ "$RET" = "0" ]
    or echo "exit code $RET at "(date "+%Y-%m-%d %H:%M:%S")
    if [ $USER = "root" ]
      echo -n 'ROOT'
    end
    set_color $PROMPT_COLOR
    echo -n '  ;'
    set_color normal
end

abbr gup  git up
abbr st   git st
abbr gl   git l
abbr gb   git bv
abbr gd   git diff --word-diff=color
abbr l    ls
abbr c    cd
abbr ..   cd ..
abbr cd.. cd ..
abbr p    pwd
abbr LANGC env LANG=C

function analyse_history -d "analyze fish shell history for often used commands"
    cat $HOME/.history_persistent_$HOSTNAME | cut -d ' ' -f 2- | sort | uniq -c | sort -n | tail -n 32
end

function analyse_history_first -d "analyze fish shell history for often used executables (first token of command)"
    cat $HOME/.history_persistent_$HOSTNAME | cut -d ' ' -f 2 | sort | uniq -c | sort -n | tail -n 32
end

function show_available_updates
    test -r /tmp/updates-available
    and cat /tmp/updates-available
    set -l UNDO_MASK (umask -p)
    umask 0000
    test -x /usr/lib/update-notifier/apt-check
    and /usr/lib/update-notifier/apt-check --human-readable >/tmp/updates-available &
    eval $UNDO_MASK
end

function fish_greeting
    command -v fortune ^/dev/null
    and command -v cowthink ^/dev/null
    and fortune -s "$HOME/.config/fortune/my_cookies" | cowthink -f tux
    set_color cyan
    date "+ %Y-%m-%d %H:%M%z   a %A in %B"
    echo " $HOSTNAME" is (uptime -p)
    show_available_updates
    set_color normal
end

function ifconfig -d "Use ip instead"
  ip -brief -color address
end

function now -d "Current datetime in ISO format"
    date -Iseconds
end
