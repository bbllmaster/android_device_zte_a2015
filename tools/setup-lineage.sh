#!/usr/bin/env bash
#
# Bootstrap a LineageOS 22.2 tree for the ZTE A2015 port.
#
# Usage:
#   ./tools/setup-lineage.sh [target-dir]
#
set -euo pipefail

LINEAGE_DIR="${1:-$HOME/android/lineage}"
ORG="${ORG:-bbllmaster}"
BRANCH="${BRANCH:-lineage-22.2}"

if ! command -v repo >/dev/null 2>&1; then
    echo "repo is not installed; see https://wiki.lineageos.org/" >&2
    exit 1
fi

mkdir -p "$LINEAGE_DIR"
cd "$LINEAGE_DIR"

if [ ! -d .repo ]; then
    repo init -u https://github.com/LineageOS/android.git -b "$BRANCH"
fi

# The device repo is not in the tree yet; clone it once so its local manifest
# can be used for the full sync.
if [ ! -d device/zte/a2015/.git ]; then
    mkdir -p device/zte
    git clone -b "$BRANCH" "https://github.com/${ORG}/android_device_zte_a2015.git" device/zte/a2015
fi

mkdir -p .repo/local_manifests
cp device/zte/a2015/local_manifests/a2015.xml .repo/local_manifests/a2015.xml

repo sync -c -j"$(nproc)" --no-clone-bundle

export USE_CCACHE=1
export CCACHE_EXEC="$(command -v ccache || true)"
if [ -n "$CCACHE_EXEC" ]; then
    ccache -M 50G >/dev/null
fi

source build/envsetup.sh
breakfast a2015

echo
echo "Tree ready. Next:"
echo "  cd $LINEAGE_DIR"
echo "  source build/envsetup.sh"
echo "  mka bootimage       # first milestone"
echo "  brunch a2015        # full ROM"
