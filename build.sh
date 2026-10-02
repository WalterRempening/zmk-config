#!/bin/bash
# Build Sweep firmware locally into ./firmware (workspace: ~/Dev/zmk-workspace).
set -e
CONFIG="$(cd "$(dirname "$0")" && pwd)"
WS="$HOME/Dev/zmk-workspace"
source "$WS/.venv/bin/activate"
export ZEPHYR_TOOLCHAIN_VARIANT=zephyr ZEPHYR_SDK_INSTALL_DIR="$HOME/zephyr-sdk-0.17.0"
mkdir -p "$CONFIG/firmware"
cd "$WS/zmk/app"
for side in left right; do
  west build -p -d "$WS/build/cradio_$side" -b nice_nano@2.0.0 -- \
    -DSHIELD=cradio_$side -DZMK_CONFIG="$CONFIG/config"
  cp "$WS/build/cradio_$side/zephyr/zmk.uf2" "$CONFIG/firmware/cradio_$side.uf2"
done
echo "Firmware: $CONFIG/firmware/cradio_{left,right}.uf2"
