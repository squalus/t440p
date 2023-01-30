## ThinkPad T440P coreboot

Tools for coreboot on ThinkPad 440P machines

### mrc.bin

According to coreboot documentation, the mrc.bin file is non-redistributable and must be generated from a ChromeOS recovery image.

https://doc.coreboot.org/northbridge/intel/haswell/mrc.bin.html

```console
nix build .#haswell-mrc-bin
```
