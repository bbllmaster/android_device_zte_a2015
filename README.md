# LineageOS 22.2 for ZTE Axon A2015 (Wi-Fi-only)

Target: ZTE A2015 / A2015U (MSM8994, Snapdragon 810), LineageOS 22.2, **Wi-Fi-only**.

The device is treated as a small Wi-Fi tablet:

- No SIM, no calls/SMS/mobile data.
- RIL / telephony is intentionally disabled (`ro.radio.noril=1`, `ro.carrier=wifi-only`).
- Wi-Fi, Bluetooth, display, touch, audio, charging are the priorities.

## Status

This is an initial scaffold, not a booting port yet. Partition sizes and the
fstab by-name path are placeholders and must be filled from the actual device.

## Required inputs

1. `adb shell cat /proc/partitions` (or `ls -l /dev/block/bootdevice/by-name`)
2. `adb shell wm size` (1080x1920 or 1440x2560)
3. Stock ROM for the exact firmware version (vendor blobs + firmware)
4. `fastboot oem device-info` output (bootloader unlock state)

## Build

Place the three repositories at:

```
device/zte/a2015          -> android_device_zte_a2015
vendor/zte/a2015          -> android_vendor_zte_a2015
kernel/zte/msm8994        -> android_kernel_zte_msm8994
```

Then:

```bash
source build/envsetup.sh
breakfast a2015
brunch a2015
```

Output:

```
out/target/product/a2015/lineage-22.2-*.zip
out/target/product/a2015/boot.img
```

## Kernel

The kernel is ZTE's A2015 Marshmallow 3.10.84 source. Import instructions are
in the kernel repository README.

## Known gaps

- Partition sizes in `BoardConfig.mk` are placeholders.
- `fstab.qcom` uses the generic `bootdevice/by-name` path; verify on device.
- Vendor blobs are not populated.
- The A2015 panel is NT35596 (1080p) on the version visible in ZTE's kernel
  source; the 2K variant needs confirmation.
- Android 15 on a 3.10 kernel needs the same legacy backports used by the
  OnePlus 2 22.2 port (memfd, binder, seccomp, etc.).
