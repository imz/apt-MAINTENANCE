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

for b in \
    sisyphus \
	lazyCacheFile \
	revert-apt-API \
    ;
do
    "$MY"/save-in-ATTIC.sh ${DRYRUN:+--dry-run} "$SUFFIX" "$b"
done

${DRYRUN:+echo} git branch -f latest-in-ATTIC sisyphus
${DRYRUN:+echo} git push -u ATTIC latest-in-ATTIC -f
