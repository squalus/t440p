{ stdenv, mkCoreboot, libreboot, me, mrc }:
let config = stdenv.mkDerivation {
  name = "coreboot-config-t440p";
  src = libreboot;
  dontBuild = true;
  installPhase = ''
    cp resources/coreboot/t440p_12mb/config/libgfxinit_corebootfb $out
    sed -i '/CONFIG_GBE_BIN_PATH=/d' $out
    sed -i '/CONFIG_IFD_BIN_PATH=/d' $out
    sed -i '/CONFIG_ME_BIN_PATH=/d' $out
    sed -i '/CONFIG_MRC_FILE=/d' $out

    echo 'CONFIG_GBE_BIN_PATH="${libreboot}/blobs/t440p/gbe.bin"' >> $out
    echo 'CONFIG_IFD_BIN_PATH="${libreboot}/blobs/t440p/ifd.bin"' >> $out
    echo 'CONFIG_ME_BIN_PATH="${me}"' >> $out
    echo 'CONFIG_MRC_FILE="${mrc}"' >> $out

    sed -i 's,src/mainboard/$(MAINBOARDDIR)/data.vbt,src/mainboard/$(MAINBOARDDIR)/variants/$(CONFIG_VARIANT_DIR)/data.vbt,g' $out
  '';
  };
in
mkCoreboot {

  name = "coreboot-t440p";

  inherit config;
}
