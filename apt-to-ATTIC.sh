#!/bin/bash -efuC
set -o pipefail

case "$1" in
    -n|--dry-run)
	readonly DRYRUN=YES
	readonly DRYRUN_RECURSIVE=
	shift
	;;
    --dry-run-rec*)
	readonly DRYRUN=YES
	readonly DRYRUN_RECURSIVE=YES
	shift
	;;
    *)
	readonly DRYRUN=
	readonly DRYRUN_RECURSIVE=
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
    printf >&2 'Saving branch %s\n' "$b"
    [ -n "$DRYRUN" ] && [ -z "$DRYRUN_RECURSIVE" ] ||
	"$MY"/save-in-ATTIC.sh ${DRYRUN_RECURSIVE:+--dry-run} "$SUFFIX" "$b"
done

${DRYRUN:+echo} git branch -f latest-in-ATTIC cksum-types-HARDCODE-blake2b-for-pkglist-indices
${DRYRUN:+echo} git push -u ATTIC latest-in-ATTIC -f
