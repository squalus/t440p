{ stdenv, coreboot, grub-payload, coreboot-utils }:
stdenv.mkDerivation {
  name = "t440p-rom";
  dontUnpack = true;
  dontBuild = true;
  nativeBuildInputs = [ coreboot-utils ];
  installPhase = ''
    mkdir $out

    cp ${coreboot} $out/coreboot.bin
    chmod u+w $out/coreboot.bin
    cbfstool $out/coreboot.bin print
    cbfstool $out/coreboot.bin add-payload -f ${grub-payload} -n fallback/payload -c lzma
    cbfstool $out/coreboot.bin add -f ${./grub-payload/grub.cfg} -n grub.cfg -t raw
    cbfstool $out/coreboot.bin add -f ${./grub-payload/grubtest.cfg} -n grubtest.cfg -t raw
    cbfstool $out/coreboot.bin print

    dd if=$out/coreboot.bin of=$out/8mb.rom bs=1M count=8
    dd if=$out/coreboot.bin of=$out/4mb.rom bs=1M skip=8
  '';

}
