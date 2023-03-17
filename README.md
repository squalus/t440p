## ThinkPad T440P coreboot

Nix build for ThinkPad T440P coreboot firmware

### Libreboot

Some blobs, the coreboot config and the pinned revisions of coreboot, grub, and me_cleaner come from Libreboot.

https://libreboot.org

### Blobs

The T440p requires several blobs to boot.

| blob | purpose | size | source |
|------|---------|------|--------|
| ifd.bin | flash file layout | 4,096 bytes | donor laptop |
| gbe.bin | Ethernet configuration | 8,192 bytes | libreboot |
| mrc.bin | DRAM initialization code | 190,180 bytes | google |
| ME9.1_5M_Production.bin | Intel ME | 122,880 bytes (cleaned) | lenovo |

Total blob size: 325,348 bytes

More information and reversing progress on ifd and gbe blobs: https://github.com/osresearch/heads/pull/1282

#### mrc.bin

According to coreboot documentation, the mrc.bin file is non-redistributable and must be generated from a ChromeOS recovery image.

https://doc.coreboot.org/northbridge/intel/haswell/mrc.bin.html

Progress on replacement: https://ticket.coreboot.org/issues/461

```console
nix build .#mrc
```

#### Intel ME

Most of the Intel Management Engine is removed from the blob using me_cleaner.

### Basic Grub ROM

The basic ROM is built with a fully sandboxed Nix build. It's very similar to the default Libreboot configuration.

```console
nix build .#rom
```

| file | purpose |
|------|---------|
| 4mb.bin | External flashing for the top chip |
| 8mb.bin | External flashing for the bottom chip |
| coreboot.bin | Internal flashing |

Intel ME stops internal flashing (using flashrom) from working. So the first flash must be done externally.

### Secure Grub ROM

There's a secure boot version of the ROM available. The public key is not included. It must be embedded manually outside the Nix build.

```console
nix build .#rom-securegrub
cp result/coreboot.bin .
cbfstool coreboot.bin add -n boot.key -f mypubkey.pub -t raw
dd if=coreboot.bin of=4mb.rom bs=1M skip=8
dd if=coreboot.bin of=8mb.rom bs=1M count=8
```

Grub verifies signatures of boot files. All files that grub loads must have a corresponding .sig file. This includes grub.cfg, kernels, initrds, etc.

Grub is set to disallow interactive editing in this mode. Invalid signatures or other boot problems will result in an unbootable system until the ROM is externally reflashed.

Users may want to customize the boot configuration in `grub-payload/grub-secureboot.cfg`.

### SeaBIOS ROM

This ROM boots to SeaBIOS.

```console
nix build .#rom-seabios
```

### Linux ROM

An example of a booting Linux kernel with a Busybox shell. There's no bootloader.

```console
nix build .#rom-tinylinux-busybox
```

### Known issues

- Grub does not detect ahci disks after a soft reboot
- Internal flashing is allowed. This can be a bug or a feature depending on your perspective. It's convenient but less secure.
