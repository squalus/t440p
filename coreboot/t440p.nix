{ stdenv, mkCoreboot, libreboot, me, mrc }:
let config = stdenv.mkDerivation {
  name = "coreboot-config-t440p";
  src = libreboot;
  dontBuild = true;
  installPhase = ''
    cp ${./config} $out
    chmod u+w $out

    echo 'CONFIG_GBE_BIN_PATH="${libreboot}/blobs/t440p/gbe.bin"' >> $out
    echo 'CONFIG_IFD_BIN_PATH="${./ifd.bin}"' >> $out
    echo 'CONFIG_ME_BIN_PATH="${me}"' >> $out
    echo 'CONFIG_MRC_FILE="${mrc}"' >> $out
  '';
  };
in
mkCoreboot {

  name = "coreboot-t440p";

  inherit config;
}
