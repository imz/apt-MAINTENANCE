#!/bin/sh -efuC
set -o pipefail

case "${1-}" in
    -n|--dry-run)
	readonly DRYRUN=YES
	shift
	;;
    *)
	readonly DRYRUN=
	;;
esac

#    one_more_time \
for b in \
	optional \
	base \
	cwd \
	cleanup \
	priv-rpm-headers \
	fix-null-mmap \
	SPtr-by-unique_ptr \
	SPtr-to-unique_ptr \
	fixes \
	PK-GOOD \
	lazyCacheFile \
	api-for-pk \
	fix-cdrom-release \
	mark-overrides \
	test-http \
	test-cdrom \
	test-gpg-pubkey \
	tests \
	params-in-tests \
	enable_check \
	tests-BASE \
	revert-dynamicmmap \
	prep \
    ;
do
    ${DRYRUN:+echo} git push @ALT --delete "$b"
    ${DRYRUN:+echo} git branch -D "$b"
done
