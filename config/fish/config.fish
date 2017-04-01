set -xg EDITOR vim
set -xg PATH $PATH $HOME/bin
set -xg PATH $PATH $HOME/bin/ldc/bin ^/dev/null
set -xg PATH $PATH $HOME/git/x10i/x10.dist/bin
set -xg PATH $PATH /afs/info.uni-karlsruhe.de/public/java/ycomp/
set -xg PATH $HOME/dev/dot/bin $PATH ^/dev/null
set -xg PATH $HOME/git/dot/bin $PATH
set -xg PATH $PATH $HOME/git/invadeSIM
set -xg PATH $HOME/.cabal/bin /opt/ghc/7.8.4/bin /opt/cabal/1.22/bin /opt/alex/3.1.4/bin /opt/happy/1.19.5/bin $PATH ^/dev/null
set -xg DEBEMAIL "Andreas Zwinkau <qznc@web.de>"

set -xg IRTSSBASE $HOME/git/irtss
set -xg PATH $PATH $IRTSSBASE/tools/bin
set -xg JAVA_HOME /usr/lib/jvm/default-java
set -xg GUROBI_HOME /data1/zwinkau/gurobi702/linux64
set -xg GRB_LICENSE_FILE {$GUROBI_HOME}/gurobi.lic
set -xg LD_LIBRARY_PATH {$GUROBI_HOME}/lib {$LD_LIBRARY_PATH}
set -xg PATH $GUROBI_HOME/bin $PATH

set -xg LANG "en_US.utf8"
set -xg LANGUAGE "$LANG"
set -xg LC_ALL "$LANG"
set -xg LC_MONETARY "de_DE.utf8"
set -xg LC_MEASUREMENT "de_DE.utf8"
set -xg LC_NUMERIC "de_DE.utf8"
set -xg LC_TIME "de_AT.utf8" # austria has better date formatting

set -xg HOSTNAME (hostname)

if test -d /data1/zwinkau/sparc-linux-4.4.2-toolchains/multilib/bin
    set -xg PATH $PATH /data1/zwinkau/sparc-linux-4.4.2-toolchains/multilib/bin
    set -xg PATH $PATH /data1/zwinkau/sparc-elf-6.1.0/bin
end

if test -d /data1/zwinkau/Android
    set -xg PATH $PATH /data1/zwinkau/android-studio/bin
    set -xg ANDROID_HOME /data1/zwinkau/Android/Sdk
    set -xg PATH $PATH $ANDROID_HOME/tools $ANDROID_HOME/platform-tools
end

if status --is-login
    echo "Login Shell!"
end

function git_prompt -d "short info about git repos if available"
    if git status > /dev/null ^ /dev/null
        set -l branch (git name-rev HEAD --name-only --always ^/dev/null)
        echo "$branch "
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
      set -g MY_WINDOW_ID (xprop -root _NET_ACTIVE_WINDOW ^/dev/null)
  end

  function postexec_test --on-event fish_postexec
      set -l RET "$status"
      set -l postexec_time (date --iso-8601=seconds)
      set -l ACTIVE_WINDOW (xprop -root _NET_ACTIVE_WINDOW ^/dev/null)
      if [ "$ACTIVE_WINDOW" != "$MY_WINDOW_ID" ]
          notify_long_running2.py "$preexec_time" "$postexec_time" "$argv" "$RET"
      end
  end
end

switch $HOSTNAME
case 'qznc*'
  set PROMPT_COLOR red
case 'i44pc*'
  set PROMPT_COLOR blue
case '*'
  set PROMPT_COLOR cyan
end

function fish_prompt -d "Write out the prompt"
    set -l RET $status
    set_color red
    [ "$RET" = "0" ]
    or echo "return code $RET at "(date "+%Y-%m-%d %H:%M:%S")
    if nb remind
        echo " "
        nb skip-remind
    end
    #set_color $fish_color_cwd
    #echo -n (git_prompt)
    set_color $PROMPT_COLOR
    echo -n '➤ '
    set_color normal
end

function g -d "alias for git"
    git $argv
end

function gup -d "alias for g up"
    g up $argv
end

function st -d "alias for g st"
    g st $argv
end

function gl -d "alias for g l"
    g l $argv
end

function gb -d "alias for g bv"
    g bv $argv
end

function gd -d "alias for git-diff"
    git diff --word-diff=color $argv
end

function gg -d "alias for gitg"
    gitg $argv
end

function k -d "alias for kakoune"
    kak $argv
end

function l -d "alias for ls with some tweaks"
    ls --color=auto -B --group-directories-first -h -v $argv
end

function m -d "alias for make"
    make LANG=C --warn-undefined-variables $argv
end

function c -d "alias for cd"
    cd $argv
end

function cd.. -d "fix my mistakes"
    cd ..
end

function cd... -d "cd shortcut"
    cd ../..
end

function cd.... -d "cd shortcut"
    cd ../../..
end

function v -d "alias for vim"
    vim -X $argv
end

function p -d "alias for pwd"
    pwd $argv
end

function journal -d "journal inside pvw"
    nb journal
end

function analyse_history -d "analyze fish shell history for often used commands"
    history | sort | uniq -c | sort -n | tail -n 32
end

function LANGC -d "set LANG=C for a single command"
    env LANG=C $argv
end

function show_available_updates
    test -r /tmp/updates-available
    and cat /tmp/updates-available
    set -l UNDO_MASK (umask -p)
    umask 0000
    /usr/lib/update-notifier/apt-check --human-readable >/tmp/updates-available &
    eval $UNDO_MASK
end

function fish_greeting
    fortune -s "$HOME/.config/fortune/my_cookies" | cowthink -f tux
    set_color cyan
    date "+ %Y-%m-%d %H:%M%z   a %A in %B"
    echo " $HOSTNAME" is (uptime -p)
    show_available_updates
    set_color normal
end

function ycomp -d "graph GUI for yFiles"
    /afs/info.uni-karlsruhe.de/public/java/ycomp/ycomp --dolayout --autoreload $argv
end

function ibc -d "command line calculator via bc"
    echo "$argv" | bc -l
end

function mailfile -d "compose mail with thunderbird attaching the given file"
    thunderbird -compose "attachment=(readlink -f $argv)" &
end
