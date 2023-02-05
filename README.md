## ThinkPad T440P coreboot

Nix build for ThinkPad T440P coreboot firmware

### Libreboot

Some blobs, the coreboot config and the pinned revisions of coreboot, grub, and me_cleaner come from Libreboot.

https://libreboot.org

### Blobs

The T440p requires several blobs to boot.

| blob | purpose | source |
|------|---------|--------|
| ifd.bin | flash file layout | libreboot |
| gbe.bin | Ethernet configuration | libreboot |
| mrc.bin | DRAM initialization code | google |
| ME9.1_5M_Production.bin | Intel ME | lenovo |

More information and reversing progress on ifd and gbe blobs: https://github.com/osresearch/heads/pull/1282

#### mrc.bin

According to coreboot documentation, the mrc.bin file is non-redistributable and must be generated from a ChromeOS recovery image.

https://doc.coreboot.org/northbridge/intel/haswell/mrc.bin.html

```console
nix build .#mrc
```

#### Intel ME

Most of the Intel Management Engine is removed from the blob using me_cleaner.

### ROM

```console
nix build .#rom
```

| file | purpose |
|------|---------|
| 4mb.bin | External flashing for the top chip |
| 8mb.bin | External flashing for the bottom chip |
| coreboot.bin | Internal flashing |

Intel ME stops internal flashing (using flashrom) from working. So the first flash must be done externally.

