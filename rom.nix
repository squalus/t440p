{ stdenv, lib, coreboot, coreboot-utils
, payload # the payload to embed in the rom
, cbfs-files ? {} # raw file to embed in cbfs
}:
let
  cbfsFileScript =
    builtins.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "cbfstool $out/coreboot.bin add -f ${value} -n ${name} -t raw") cbfs-files);
in
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
    cbfstool $out/coreboot.bin add-payload -f ${payload} -n fallback/payload -c lzma
    ${cbfsFileScript}
    cbfstool $out/coreboot.bin print

    dd if=$out/coreboot.bin of=$out/8mb.bin bs=1M count=8
    dd if=$out/coreboot.bin of=$out/4mb.bin bs=1M skip=8
  '';

}
