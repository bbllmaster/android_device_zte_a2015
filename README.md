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
| Display | 1440x2560, `ro.sf.lcd_density=640` (2K 尊享版) |
| Storage | 128 GB eMMC (`mmcblk0` = 122138624 KiB) |
| System tree | 2.84 GiB |
| Boot image | 22.9 MB |
| Stock fstab | `bootdevice/by-name/{system,cache,userdata,persist,modem,bluetooth}` |

Partitions measured on the device:

| Partition | KiB | Bytes |
|---|---|---|
| `mmcblk0` | 122138624 | 125,069,950,976 |
| `mmcblk0p23` (system) | 3145728 | 3,221,225,472 |
| `mmcblk0p24` (cache) | 307200 | 314,572,800 |
| `mmcblk0p25` (boot) | 32768 | 33,554,432 |
| `mmcblk0p32` (userdata) | 117813231 | 120,640,748,544 |

The stock `boot.img` contains 42 appended DTBs. The A2015 entry is
`MSM8994v2.1 + PMI8994 + PM8004 CDP` (`qcom,board-id = <1 0>`); it carries the
**r63419 Sharp WQHD dual-DSI** panel nodes and the Synaptics DSX touch node,
which matches the 1440x2560 panel on this unit. ZTE's `msm8994-cdp.dtsi` already
selects r63419 as `qcom,dsi-pref-prim-pan`, so the kernel defaults to 2K.

## Status

Pre-build scaffold is in place; not booting yet.

Done:

- Device tree: product makefiles, `BoardConfig.mk`, `fstab.qcom`
- Init scripts: `init.qcom.rc`, `init.qcom.usb.rc`, `init.target.rc`, `ueventd.qcom.rc`
- Kernel: ZTE 3.10.84 source committed on `lineage-22.2`; GitHub Actions kernel build is green
- Vendor: `extract-files.py` + `proprietary-files.txt`; 80 blobs (83 MiB) extracted locally
- Bootstrap: `tools/setup-lineage.sh`

Remaining:

- `by-name` mapping for boot/recovery (verify `mmcblk0p25` is `boot`)
- Live board ID / DTB confirmation (`/proc/device-tree/model`)
- Bootloader unlock state
- Vendor destination review (firmware paths, HAL relocation)
- Full ROM build on a 400GB+ host

## Required inputs

1. `adb shell ls -l /dev/block/bootdevice/by-name`
2. `adb shell cat /proc/device-tree/model`
3. `fastboot oem device-info` output (bootloader unlock state)

## Build

Quick start:

```bash
./tools/setup-lineage.sh ~/android/lineage
```

The script initializes LineageOS 22.2, clones the device repo, installs the
local manifest, syncs the three repositories, and runs `breakfast a2015`.

Vendor blobs must be extracted before building:

```bash
cd device/zte/a2015
./extract-files.py --rom /path/to/update.zip --vendor ../../../vendor/zte/a2015
```

`proprietary/` is gitignored; the blobs stay local.

Then:

```bash
cd ~/android/lineage
source build/envsetup.sh
mka bootimage   # first milestone
brunch a2015    # full ROM
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

- Vendor blobs are not populated. The stock `system/vendor` is 233 MiB and the
  HAL modules are in `system/lib/hw` / `system/lib64/hw`.
- `system` is exactly 3 GiB. A LineageOS 22.2 arm64 build with vendor inside
  `/system/vendor` may be tight; if the image overflows, trim packages or drop
  the unused 64-bit HALs.
- Android 15 on a 3.10 kernel needs the same legacy backports used by the
  OnePlus 2 22.2 port (memfd, binder, seccomp, etc.).
