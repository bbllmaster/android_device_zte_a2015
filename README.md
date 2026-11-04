# LineageOS 22.2 for ZTE Axon A2015 (Wi-Fi-only)

Target: ZTE A2015 / P894A02 (MSM8994, Snapdragon 810), LineageOS 22.2,
**Wi-Fi-only**.

The device is treated as a small Wi-Fi tablet:

- No SIM, no calls/SMS/mobile data.
- RIL / telephony is intentionally disabled (`ro.radio.noril=1`, `ro.carrier=wifi-only`).
- Wi-Fi, Bluetooth, display, touch, audio, charging are the priorities.

## Confirmed from the stock ROM

Stock package: `20161226142336257.zip` → `update.zip`

| Item | Value |
|---|---|
| Build | `ZTE_A2015V1.0.0B16_M` |
| Android | 6.0.1 / MMB29M |
| Fingerprint | `ZTE/P894A02/msm8994:6.0.1/MMB29M/zte.20161216.133146:user/release-keys` |
| Product | `P894A02`, model `ZTE A2015` |
| Board | `msm8994` |
| Display | 1920x1080, `ro.sf.lcd_density=640` |
| System tree | 2.84 GiB |
| Boot image | 22.9 MB |
| Stock fstab | `bootdevice/by-name/{system,cache,userdata,persist,modem,bluetooth}` |

The stock `boot.img` contains 42 appended DTBs. The A2015 candidate is
`MSM8994v2.1 + PMI8994 + PM8004 CDP` (`qcom,board-id = <1 0>`), which contains
the NT35596 1080p panels and Synaptics DSX touch node. Confirm the live board ID
on the device before relying on it.

## Status

Initial scaffold, not a booting port yet. Partition sizes and the exact board
DTB still need confirmation.

## Required inputs

1. `adb shell cat /proc/partitions` (or `ls -l /dev/block/bootdevice/by-name`)
2. `adb shell getprop | grep -E 'ro.boot|board'`
3. `adb shell cat /proc/device-tree/model`
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

- Partition sizes in `BoardConfig.mk` are still estimates; userdata and cache
  must come from the device.
- Vendor blobs are not populated. The stock `system/vendor` is 233 MiB and the
  HAL modules are in `system/lib/hw` / `system/lib64/hw`.
- The 2K panel variant is not present in this B16 package; this package is 1080p.
- Android 15 on a 3.10 kernel needs the same legacy backports used by the
  OnePlus 2 22.2 port (memfd, binder, seccomp, etc.).
