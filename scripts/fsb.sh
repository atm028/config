#!/bin/zsh

function fsb() {
    local pattern=$*
        local branches branch
        branches=$(git branch --all | awk 'tolower($0) ~ /'"$pattern"'/') &&
        branch=$(echo "$branches" | fzf-tmux -p --reverse -1 -0 +m) &&
        if [ "$branch" = ""]; then
            echo "[$0] No branch mathces ther pattern"; return
    fi;
    git checkout "$(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")"
}
fsb "$@"
