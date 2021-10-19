#!/bin/sh -efuC
set -o pipefail

case "$1" in
    -n|--dry-run)
	readonly DRYRUN=YES
	shift
	;;
    *)
	readonly DRYRUN=
	;;
esac
readonly SUFFIX="$1"; shift

readonly MY="${0%/*}"

readonly -a BRANCHES=(
    $(git --no-pager branch \
	  --contains 0.5.15lorg2-alt72 \
	  --format='%(refname:short)' \
	  | fgrep -v -x latest-in-ATTIC \
	  | fgrep -v -x callbacks \
	  | fgrep -v -x test-corrupt-lists-REVERT \
	  | fgrep -v -x test-cksum-of-pkglist-index-HARDCODE
    )
)

for b in "${BRANCHES[@]}";
do
    if git merge-base --is-ancestor "$b" latest-in-ATTIC; then
	printf >&2 'Skipping already saved branch %s\n' "$b"
	continue
    fi
    "$MY"/save-in-ATTIC.sh ${DRYRUN:+--dry-run} "$SUFFIX" "$b"
done

${DRYRUN:+echo} git branch -f latest-in-ATTIC cksum-types-HARDCODE-sha1
${DRYRUN:+echo} git push -u ATTIC latest-in-ATTIC -f
