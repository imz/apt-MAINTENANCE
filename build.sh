#!/bin/sh -efuCx
set -o pipefail

readonly HSHDIR="$1"; shift

#hsh --clean "$HSHDIR"
# Don't delete the cache:
rm -rfv "$HSHDIR"/repo

############################################################
cd ../apt
#readonly X_rev=wip
#readonly X_rev=cksum-types-sha1
#readonly X_rev=cksum-types
readonly X_rev=wip
#readonly X_rev=test-cksum-for-archives
#readonly X_rev=alt
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
     hsh --without-stuff "$HSHDIR" \
     --build-args="--define 'disttag sisyphus+$(git rev-parse "$X_rev")'"

# gear -t "$X_rev" --no-compress --hasher -- \
#      hsh-rebuild "$HSHDIR" \
#      --args="--define 'disttag sisyphus+$(git rev-parse "$X_rev")'"

############################################################
cd ../apt-repo-tools/
readonly W_rev=@ALT/sha2
#readonly W_rev=gears/sisyphus

# --disable check ? (anyway it will be tested in girar)
gear -t "$W_rev" --no-compress --hasher -- \
     hsh --with-stuff "$HSHDIR" \
     --build-args="--define 'disttag sisyphus+$(git rev-parse "$W_rev")' --disable check"

# gear -t "$W_rev" --no-compress --hasher -- \
#      hsh-rebuild "$HSHDIR" \
#      --args="--define 'disttag sisyphus+$(git rev-parse "$W_rev")'"

hsh --with-stuff --ini "$HSHDIR"
hsh-install "$HSHDIR" apt-basic-checkinstall

hsh --with-stuff --ini "$HSHDIR"
hsh-install "$HSHDIR" apt-checkinstall

hsh --with-stuff --ini "$HSHDIR"
hsh-install "$HSHDIR" apt-heavyload-checkinstall

# ############################################################
# cd ../packagekit/
# readonly Z_rev=gears/sisyphus
# #readonly Z_rev=new-ABI-tmp
# #readonly Z_rev=lazyCacheFile
# #readonly Z_rev=lazyCacheFile~1

# gear -t "$Z_rev" --no-compress --hasher -- \
#      hsh --with-stuff "$HSHDIR" \
#      --build-args="--define 'disttag sisyphus+$(git rev-parse "$Z_rev")'"

# # gear -t "$Z_rev" --no-compress --hasher -- \
# #      hsh-rebuild "$HSHDIR" \
# #      --args="--define 'disttag sisyphus+$(git rev-parse "$Z_rev")'"

# ../apt/test-pk-in-hsh.sh --ini SAME "$HSHDIR"


# ############################################################
# cd ../synaptic/
# readonly Y_rev=gears/sisyphus
# #readonly Y_rev=sisyphus
# # C++17
# #readonly Y_rev=sisyphus~3
# # unique_ptr returned (APT: fix-null-mmap)
# #readonly Y_rev=sisyphus~4
# # ctor wants ref
# #readonly Y_rev=sisyphus~5
# #readonly Y_rev=sisyphus~6

# gear -t "$Y_rev" --no-compress --hasher -- \
#      hsh --with-stuff "$HSHDIR" \
#      --build-args="--define 'disttag sisyphus+$(git rev-parse "$Y_rev")'"

# ############################################################
# cd ../apt-indicator/
# #readonly A_rev=sisyphus
# readonly A_rev=gears/sisyphus
# #readonly A_rev=lazyCacheFile
# #readonly A_rev=revert-apt-ABI

# gear -t "$A_rev" --no-compress --hasher -- \
#      hsh --with-stuff "$HSHDIR" \
#      --build-args="--define 'disttag sisyphus+$(git rev-parse "$A_rev")'"

# # gear -t "$A_rev" --no-compress --hasher -- \
# #      hsh-rebuild "$HSHDIR" \
# #      --args="--define 'disttag sisyphus+$(git rev-parse "$A_rev")'"


# ############################################################
# cd ../aptitude/
# readonly B_rev=gears/sisyphus
# #readonly B_rev=alt
# #readonly B_rev=alt~2
# #readonly B_rev=unique_ptr-to-return-mmap
# # ctor wants ref
# #readonly B_rev=unique_ptr-to-return-mmap^
# #readonly B_rev=lazyCacheFile
# #readonly B_rev=p8

# gear -t "$B_rev" --no-compress --hasher -- \
#      hsh --with-stuff "$HSHDIR" \
#      --build-args="--define 'disttag sisyphus+$(git rev-parse "$B_rev")'"

# # gear -t "$B_rev" --no-compress --hasher -- \
# #      hsh-rebuild "$HSHDIR" \
# #      --args="--define 'disttag sisyphus+$(git rev-parse "$B_rev")'"

# ############################################################
# cd ../perl-AptPkg/
# readonly C_rev=gears/sisyphus
# #readonly C_rev=master
# #readonly C_rev=lazyCacheFile

# gear -t "$C_rev" --no-compress --hasher -- \
#      hsh --with-stuff "$HSHDIR" \
#      --build-args="--define 'disttag sisyphus+$(git rev-parse "$C_rev")'"

# # gear -t "$C_rev" --no-compress --hasher -- \
# #      hsh-rebuild "$HSHDIR" \
# #      --args="--define 'disttag sisyphus+$(git rev-parse "$C_rev")'"
