#!/bin/sh -efuCx
set -o pipefail

readonly HSHDIR="$1"; shift
readonly HSHARGS=(--workdir="$HSHDIR" "$@")

#hsh --clean "$HSHDIR"
# Don't delete the cache:
rm -rfv "$HSHDIR"/repo

############################################################
cd ../apt
readonly X_rev=wip
#readonly X_rev=gears/sisyphus
#readonly X_rev=cksum-types-sha1
#readonly X_rev=cksum-types
#readonly X_rev=@ALT/pkgprio-bufsize
#readonly X_rev=test-cksum-for-archives
#readonly X_rev=gpg-keygen-inside
#readonly X_rev=alt~1
#readonly X_rev=test-apt-conf-dump-sort
#readonly X_rev=virtual-has-no-default-param
#readonly X_rev=one_more_time
#readonly X_rev=base
#readonly X_rev=restore-virtual-sig
#readonly X_rev=priv-rpm-headers
# unique_ptr returned
#readonly X_rev=fix-null-mmap
# ctor wants ref
#readonly X_rev=fix-null-mmap~2
#readonly X_rev=fixes
#readonly X_rev=lazyCacheFile
# delete Close()
#readonly X_rev=lazyCacheFile~5
#readonly X_rev=api-for-pk

# --disable check ?
gear -t "$X_rev" --no-compress --hasher -- \
     hsh --without-stuff "${HSHARGS[@]}" \
     --build-args="--define 'disttag %(rpm --eval %%_priority_distbranch)+$(git rev-parse "$X_rev")'"

# gear -t "$X_rev" --no-compress --hasher -- \
#      hsh-rebuild --workdir="$HSHDIR" \
#      --args="--define 'disttag %(rpm --eval %%_priority_distbranch)+$(git rev-parse "$X_rev")'"

############################################################
cd ../apt-repo-tools/
#readonly W_rev=@ALT/sha2
readonly W_rev=gears/sisyphus

# --disable check ? (anyway it will be tested in girar)
gear -t "$W_rev" --no-compress --hasher -- \
     hsh --with-stuff "${HSHARGS[@]}" \
     --build-args="--define 'disttag %(rpm --eval %%_priority_distbranch)+$(git rev-parse "$W_rev")' --disable check"

# gear -t "$W_rev" --no-compress --hasher -- \
#      hsh-rebuild --workdir="$HSHDIR" \
#      --args="--define 'disttag %(rpm --eval %%_priority_distbranch)+$(git rev-parse "$W_rev")'"

############################################################
hsh --with-stuff --ini "${HSHARGS[@]}"
# hack for large-rpm-archive test (which uses openssl)
#hsh-install --workdir="$HSHDIR" openssl
hsh-install --workdir="$HSHDIR" apt-basic-checkinstall

# hsh --with-stuff --ini "${HSHARGS[@]}"
# hsh-install --workdir="$HSHDIR" apt-checkinstall

# hsh --with-stuff --ini "${HSHARGS[@]}"
# hsh-install --workdir="$HSHDIR" apt-xxtra-heavy-load-checkinstall

############################################################
# More thorough (longer) tests.

hsh --with-stuff --ini "${HSHARGS[@]}"
hsh-install --workdir="$HSHDIR" apt-checkinstall

hsh --with-stuff --ini "${HSHARGS[@]}"
hsh-install --workdir="$HSHDIR" apt-xxtra-heavy-load-checkinstall
