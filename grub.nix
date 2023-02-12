{ stdenv, coreboot-toolchain
, autoconf, automake, gettext, pkg-config, unifont
, bison, flex, python3, freetype
, src, gnulib-src, libreboot
 }:
stdenv.mkDerivation {

  name = "grub-coreboot";

  nativeBuildInputs = [ coreboot-toolchain.i386 autoconf automake gettext pkg-config bison flex python3 freetype ];

  inherit src;

  patches = [
    "${libreboot}/resources/grub/patches/0001-mitigate-grub-s-missing-characters-for-borders-arrow.patch"
  ];

  postPatch = ''
    cp -r ${gnulib-src} gnulib
    chmod -R a+w .
    patchShebangs .
  '';

  preConfigure = ''
    ./bootstrap --no-git --gnulib-srcdir=gnulib/
    ./autogen.sh
     substituteInPlace ./configure --replace '/usr/share/fonts/unifont' '${unifont}/share/fonts'
  '';

  configureFlags = [
    "--with-platform=coreboot"
  ];
}

