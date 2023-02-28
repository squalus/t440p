{ stdenv, lib, cpio, busybox }:
stdenv.mkDerivation {

  name = "busybox-initramfs";

  nativeBuildInputs = [ cpio ];

  dontUnpack = true;

  buildPhase = ''
    mkdir root
    cd root
    mkdir bin
    cp ${busybox}/bin/busybox bin/busybox
    chmod u+x bin/busybox

    cp ${./init.sh} init
    chmod u+x init

    find . | cpio -ov --format=newc > ../initramfs.cpio
    cd ..

    xz --check=crc32 --lzma2=dict=512KiB initramfs.cpio
  '';

  installPhase = ''
    mv initramfs.cpio.xz $out
  '';
}

