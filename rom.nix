{ stdenv, lib, coreboot, coreboot-utils
, elfPayload ? null # the payload to embed in the rom
, compressPayload ? true # whether to enable lzma for payload
, linuxKernelPayload ? null
, linuxInitrd ? null
, linuxCmdline ? ""
, cbfs-files ? {} # raw file to embed in cbfs
, cbfs-ints ? {} # int values to embed in cbfs
}:
let
  cbfsFileScript =
    builtins.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "cbfstool $out/coreboot.bin add -f ${value} -n ${name} -t raw") cbfs-files);
  cbfsIntScript =
    builtins.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "cbfstool $out/coreboot.bin add-int -i ${builtins.toString value} -n ${name}") cbfs-ints);
  elfPayloadScript = ''
    cbfstool $out/coreboot.bin add-payload \
      -f ${lib.escapeShellArg elfPayload} \
      -n fallback/payload \
       ${lib.optionalString compressPayload "-c lzma"}
  '';
  linuxPayloadScript = ''
    cbfstool $out/coreboot.bin add-payload \
      -f ${lib.escapeShellArg linuxKernelPayload} \
      -n fallback/payload \
      -I ${lib.escapeShellArg linuxInitrd} \
      -C ${lib.escapeShellArg linuxCmdline}
  '';
  payloadScript = if (linuxKernelPayload == null) then elfPayloadScript else linuxPayloadScript;

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

    ${payloadScript}
    ${cbfsFileScript}
    ${cbfsIntScript}

    cbfstool $out/coreboot.bin print

    dd if=$out/coreboot.bin of=$out/8mb.bin bs=1M count=8
    dd if=$out/coreboot.bin of=$out/4mb.bin bs=1M skip=8
  '';

}
