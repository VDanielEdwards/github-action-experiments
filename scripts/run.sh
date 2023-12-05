#!/bin/bash

set -e

SIL_KIT_SOURCE_DIR="sil-kit"

get_sil_kit_version_component() {
    sed -n -E "s/^[[:space:]]*set[[:space:]]*[(][[:space:]]*SILKIT_VERSION_${1}[[:space:]]+([[:digit:]]+)[[:space:]]*[)].*$/\1/p" "${SIL_KIT_SOURCE_DIR}/SilKit/cmake/SilKitVersion.cmake"
}

SIL_KIT_MAJOR="$(get_sil_kit_version_component MAJOR)"
SIL_KIT_MINOR="$(get_sil_kit_version_component MINOR)"
SIL_KIT_PATCH="$(get_sil_kit_version_component PATCH)"

SIL_KIT_PACKAGE_NAME="libsilkit_${SIL_KIT_MAJOR}.${SIL_KIT_MINOR}.${SIL_KIT_PATCH}"

rm -rf "${SIL_KIT_SOURCE_DIR}/debian"
cp -r debian "${SIL_KIT_SOURCE_DIR}/debian"

sed -i \
    -e "s/SIL_KIT_MAJOR/${SIL_KIT_MAJOR}/g" \
    -e "s/SIL_KIT_MINOR/${SIL_KIT_MINOR}/g" \
    -e "s/SIL_KIT_PATCH/${SIL_KIT_PATCH}/g" \
    "${SIL_KIT_SOURCE_DIR}/debian/changelog"


# echo "-- creating source tarball"
tar -c -a -C "${SIL_KIT_SOURCE_DIR}" -f "libsilkit_${SIL_KIT_MAJOR}.${SIL_KIT_MINOR}.${SIL_KIT_PATCH}.orig.tar.gz" .

cd "${SIL_KIT_SOURCE_DIR}"

ls -l .
ls -l ..

echo "-- debuild"
debuild -us -uc

ls -l .
ls -l ..

