{ stdenv, grub-coreboot }:
stdenv.mkDerivation {
  name = "grub-payload";
  dontUnpack = true;
  dontBuild = true;
  nativeBuildInputs = [ grub-coreboot ];
  installPhase = ''
    mkdir memdisk
    cd memdisk
    grub-mkstandalone \
      -O i386-coreboot \
      -o $out \
      --modules="acpi affs afs afsplitter ahci aout at_keyboard all_video archelp ata bitmap bitmap_scale blocklist boot bsd btrfs cat cbfs cbls cbmemc cbtime chain cmosdump cmostest cmp configfile cpio cpio_be crc64 crypto cryptodisk cs5536 date datehook datetime disk diskfilter echo efiemu ehci eval elf extcmd exfat ext2 f2fs fat file fshelp gcry_arcfour gcry_blowfish gcry_camellia gcry_cast5 gcry_crc gcry_des gcry_dsa gcry_idea gcry_md4 gcry_md5 gcry_rfc2268 gcry_rijndael gcry_rmd160 gcry_rsa gcry_seed gcry_serpent gcry_sha1 gcry_sha256 gcry_sha512 gcry_tiger gcry_twofish gcry_whirlpool gfxmenu gfxterm_background gfxterm_menu gptsync gzio halt hashsum hdparm help iorw iso9660 json jpeg json keylayouts keystatus ldm linux linux16 loadenv loopback ls lsacpi lsmmap lspci luks luks2 lvm lzopio mdraid09 mdraid09_be mdraid1x memdisk memrw minicmd mmap msdospart multiboot multiboot2 nativedisk normal ntfs ntfscomp ohci part_bsd part_dfly part_gpt part_msdos parttool password password_pbkdf2 pata pbkdf2 pci pcidump pgp play png priority_queue probe procfs progress raid5rec raid6rec random read reboot regexp relocator romfs scsi search search_fs_file search_fs_uuid search_label serial syslinuxcfg setjmp setpci sleep smbios spkmodem squash4 sfs tar terminal terminfo test time tga true tr trig udf uhci usb usb_keyboard usbms xfs xzio zfs zfscrypt zfsinfo zstd" \
      --install-modules="adler32 backtrace bfs bswap_test cmdline_cat_test cmp_test cpuid ctz_test div div_test dm_nv exfctest functional_test gdb geli gettext hello hexdump hfs hfsplus hfspluscomp http jfs macbless macho mda_text minix minix2 minix2_be minix3 minix3_be minix_be morse mpi mul_test net newc nilfs2 odc offsetio part_acorn part_amiga part_apple part_dvh part_plan part_sun part_sunpc pbkdf2_test rdmsr reiserfs setjmp_test shift_test signature_test sleep_test strtoull_test test_blockarg testload testspeed tftp ufs1 ufs1_be ufs2 usbserial_common usbserial_ftdi usbserial_pl2303 usbserial_usbdebug usbtest video_bochs video_cirrus video_colors videoinfo videotest videotest_checksum wrmsr xnu xnu_uuid xnu_uuid_test" \
      --fonts= --themes= --locales= \
      /boot/grub/grub.cfg=${./grub_memdisk.cfg}
  '';
}
