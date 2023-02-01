{ grub2, gnulib }:
grub2.overrideAttrs (old: {
  buildInputs = old.buildInputs ++ [ gnulib ];

  configureFlags = old.configureFlags ++ [
    "--with-platform=coreboot"
  ];

  preBuild = (old.preBuild or "") + ''
    makeFlagsArray+=(TARGET_CFLAGS="-Os -fno-reorder-functions")
  '';

  postBuild = (old.postBuild or "") + ''
    make default_payload.elf
    find .
  '';

  separateDebugInfo = false;

  postInstall = (old.postInstall or "") + ''
    rm -rf $out
    cp default_payload.elf $out
  '';
})
