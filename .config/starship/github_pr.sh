#!/usr/bin/env bash
# Renderer only: print a colored PR badge for the CURRENT directory's repo +
# branch to stdout (nothing if there's no PR or gh fails). Caching, staleness
# and async redraw live in github-prompt.zsh; this runs inside its background
# worker, so the gh fork here never blocks the prompt. One gh call -- gh's own
# --jq does the field extraction, so we don't fork jq four times.
data=$(gh pr view --json number,state,isDraft,reviewDecision \
  --jq '[.number, .state, .isDraft, .reviewDecision] | @tsv' 2>/dev/null) || exit 0
[ -n "$data" ] || exit 0
IFS=$'\t' read -r number state isDraft review <<<"$data"
if [ "$state" = "MERGED" ]; then color='[38;2;137;87;229m'; icon=' '
elif [ "$state" = "CLOSED" ]; then color='[31m'; icon=' '
elif [ "$isDraft" = "true" ]; then color='[90m'; icon=' '
elif [ "$review" = "APPROVED" ]; then color='[32m'; icon=' '
elif [ "$review" = "CHANGES_REQUESTED" ]; then color='[31m'; icon=' '
else color='[33m'; icon=' '
fi
echo -n "${color}${icon}#${number}[0m"
