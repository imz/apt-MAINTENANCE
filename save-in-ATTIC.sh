#!/bin/sh -efuCx
set -o pipefail

case "$1" in
    -n|--dry-run)
	set +x
	readonly DRYRUN=yes
	shift
	;;
    *)
	readonly DRYRUN=
	;;
esac
readonly SUFFIX="$1"; shift
readonly BRANCH="$1"; shift

base="$(git describe --abbrev=0 "$BRANCH"^)"
readonly base

branch_in_ATTIC="$base$SUFFIX"/"$BRANCH"

[ "$(git rev-parse "$branch_in_ATTIC" 2>/dev/null)" = "$(git rev-parse "$BRANCH")" ] ||
    ${DRYRUN:+echo} git branch "$branch_in_ATTIC" "$BRANCH"
${DRYRUN:+echo} git push -u ATTIC "$branch_in_ATTIC" --follow-tags
${DRYRUN:+echo} git branch -d "$branch_in_ATTIC"
