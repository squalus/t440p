{ fetchgit, stdenv, fetchzip, getopt, lib }:
fetchgit {
  url = "https://review.coreboot.org/coreboot";
  # todo - extract from libreboot resources/coreboot/default/board.cfg
  rev = "e70bc423f9a2e1d13827f2703efe1f9c72549f20"; # libreboot's rev
  hash = "sha256-lisBjoBKsgQOtjINZKFUmn9GdTAyrgvUBIXKu73mGiE=";
  fetchSubmodules = true;
  leaveDotGit = true;
  postFetch = ''
    PATH=${lib.makeBinPath [ getopt ]}:$PATH ${stdenv.shell} $out/util/crossgcc/buildgcc -W > $out/.crossgcc_version
    rm -rf $out/.git
  '';
  allowedRequisites = [ ];
}


