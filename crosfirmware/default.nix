{ stdenv, lib, callPackage, coreboot-utils, sharutils, curl, unzip, e2fsprogs, parted, util-linux, makeWrapper }:
stdenv.mkDerivation {
  name = "crosfirmware";
  nativeBuildInputs = [ makeWrapper ];
  src = callPackage ../coreboot-src.nix {};
  dontBuild = true;
  patches = [
    # modify the script to hack out the file download steps and allow an already-downloaded file to be provided
    ./dont-download.patch
  ];
  installPhase = ''
    mkdir -p $out/bin
    cp util/chromeos/crosfirmware.sh $out/bin
    wrapProgram $out/bin/crosfirmware.sh \
      --prefix PATH : "${lib.makeBinPath [ sharutils curl unzip e2fsprogs parted util-linux coreboot-utils ]}"
  '';

}
