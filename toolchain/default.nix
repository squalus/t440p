{ callPackage, coreboot-toolchain }:
coreboot-toolchain.i386.overrideAttrs (old: {
  src = (callPackage (import ../coreboot-src.nix) {});
})
