{ stdenv, fetchgit, getopt, lib }:
fetchgit {
  url = "https://review.coreboot.org/coreboot";
  rev = "4.19";
  sha256 = "sha256-pGS+bfX2k/ot7sHL9aiaQpA0wtbHHZEObJ/h2JGF5/4=";
  fetchSubmodules = false;
  leaveDotGit = true;
  postFetch = ''
    PATH=${lib.makeBinPath [ getopt ]}:$PATH ${stdenv.shell} $out/util/crossgcc/buildgcc -W > $out/.crossgcc_version
    rm -rf $out/.git
  '';
  allowedRequisites = [ ];
}

