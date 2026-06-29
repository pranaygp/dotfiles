# ~/.config/starship/github-prompt.zsh
#
# Fast, deferred GitHub segments for Starship.
#
# Why this exists: SentinelOne (EDR) adds ~0.3s of latency to EVERY process
# spawn on this machine, so cost here is dominated by *how many subprocesses*
# the prompt forks, not by the work they do. The old setup forked a shell for
# each of three custom modules' `when:` conditions, and github_pr.sh forked
# gh/jq/bkt (~8 procs) on every miss -> 1.6s in $HOME, 3-5s in a repo, plus the
# Starship command_timeout WARNings.
#
# This file does all per-prompt work with zsh builtins (zero forks) and defers
# the only thing that genuinely needs a subprocess -- `gh pr view` -- to a
# background worker with stale-while-revalidate caching and an async prompt
# redraw. It feeds three env vars that starship.toml renders via [env_var]
# modules (env_var reads are fork-free; custom modules are not):
#
#   STARSHIP_GH_REPO  "vercel/next.js"  org/repo for ~/github paths (worktrees collapsed)
#   STARSHIP_GH_WT    "fix-build"       worktree suffix from the repo--branch convention
#   STARSHIP_GH_PR    pre-rendered "#123" badge, computed off the hot path

zmodload zsh/datetime 2>/dev/null   # $EPOCHSECONDS   (fork-free clock)
zmodload zsh/stat 2>/dev/null       # zstat           (fork-free stat)
zmodload zsh/system 2>/dev/null     # zsystem flock   (fork-free lock)
autoload -Uz add-zsh-hook

typeset -g  _GH_PR_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/starship-gh-pr"
typeset -g  _GH_PR_RENDERER="${${(%):-%x}:A:h}/github_pr.sh"
typeset -g  _GH_PR_SHELL_PID=$$
typeset -gi _GH_PR_STALE=45          # seconds before a background refresh fires
[[ -d $_GH_PR_DIR ]] || mkdir -p $_GH_PR_DIR

# Read the cached badge for the current $PWD into STARSHIP_GH_PR, fork-free.
# env_var modules render their wrapper even when the value is empty, so we must
# *unset* -- not blank -- the var when there is nothing to show.
_gh_pr_load() {
  local f="$_GH_PR_DIR/${PWD//[^[:alnum:]]/_}" v=''
  [[ -r $f ]] && v="$(<$f)"
  if [[ -n $v ]]; then export STARSHIP_GH_PR="$v"; else unset STARSHIP_GH_PR; fi
}

# Background worker: render the badge (one gh call via github_pr.sh), write it
# to the cache atomically, then nudge the interactive shell to repaint. Runs
# disowned via `&!`, so its EDR-taxed forks never block the prompt.
_gh_pr_worker() {
  emulate -L zsh
  exec 2>/dev/null                       # silence this disowned background worker
  local dir=$1 f=$2 lockfd out
  [[ -d $_GH_PR_DIR ]] || mkdir -p -- "$_GH_PR_DIR"
  # Non-blocking lock so concurrent prompts don't stack workers for one dir.
  # zsystem flock opens the lock file but won't create it, so ensure it exists
  # first (fork-free). It stows the fd in $lockfd; the lock releases when this
  # subshell exits and the fd closes.
  : >> "$f.lock"
  zsystem flock -t 0 -f lockfd "$f.lock" || return
  # Double-checked: another worker may have refreshed the cache while we waited
  # for the lock, so don't fire a redundant gh call.
  local -a st
  zstat -A st +mtime -- "$f" 2>/dev/null && (( EPOCHSECONDS - st[1] < _GH_PR_STALE )) && return
  builtin cd -q -- "$dir" || return
  out="$(command "$_GH_PR_RENDERER")"
  print -rn -- "$out" > "$f.tmp" && mv -f "$f.tmp" "$f"
  kill -USR1 $_GH_PR_SHELL_PID
}

# precmd: pure-builtin path parsing + cache read. Spawns a worker only when the
# cache is stale/missing, and only inside ~/github repos, so $HOME and other
# directories stay completely fork-free.
_gh_prompt_precmd() {
  emulate -L zsh
  local rel org full f
  local -a st
  # 1. org/repo + worktree from the path -- no subprocess.
  if [[ $PWD = $HOME/github/*/* ]]; then
    rel=${PWD#$HOME/github/}
    org=${rel%%/*}
    full=${${rel#*/}%%/*}
    if [[ $full = *--* ]]; then
      export STARSHIP_GH_REPO="$org/${full%%--*}"
      export STARSHIP_GH_WT="${full#*--}"
    else
      export STARSHIP_GH_REPO="$org/$full"
      unset STARSHIP_GH_WT
    fi
  else
    unset STARSHIP_GH_REPO STARSHIP_GH_WT STARSHIP_GH_PR
    return   # not a github repo: no PR badge, no background work
  fi
  # 2. PR badge from cache; refresh in the background if stale or missing.
  f="$_GH_PR_DIR/${PWD//[^[:alnum:]]/_}"
  if [[ -r $f ]]; then
    _gh_pr_load
    if zstat -A st +mtime -- $f 2>/dev/null && (( EPOCHSECONDS - st[1] >= _GH_PR_STALE )); then
      _gh_pr_worker "$PWD" "$f" &!
    fi
  else
    unset STARSHIP_GH_PR
    _gh_pr_worker "$PWD" "$f" &!
  fi
}

# When a worker finishes it sends SIGUSR1; re-read the cache and repaint in
# place so the badge appears (or updates) without waiting for the next command.
TRAPUSR1() { _gh_pr_load; zle && zle reset-prompt }

add-zsh-hook precmd _gh_prompt_precmd
