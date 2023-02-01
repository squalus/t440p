{ fetchzip, runCommand, lib, crosfirmware, coreboot-utils }:

let


in

runCommand "haswell-mrc-bin" {
  src = fetchzip {
    url = "https://dl.google.com/dl/edgedl/chromeos/recovery/chromeos_12239.92.0_peppy_recovery_stable-channel_mp-v3.bin.zip";
    hash = "sha256-jVQoZNR+mx0y3W9R3OM1f+4/0nZzLUeoLw+xufagX4U=";
    postFetch = ''
      mv $out/chromeos* ./file
      rm -rf $out
      mv file $out
    '';
  };
  nativeBuildInputs = [ crosfirmware coreboot-utils ];
  meta.url = "https://doc.coreboot.org/northbridge/intel/haswell/mrc.bin.html";
} ''
  env RECOVERY_IMAGE_FILE=$src crosfirmware.sh peppy
  cbfstool coreboot-*.bin extract -f mrc.bin -n mrc.bin -r RO_SECTION
  mv mrc.bin $out
''
