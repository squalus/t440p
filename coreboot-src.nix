{ fetchgit, stdenv, fetchzip, getopt, lib }:
fetchgit {
  url = "https://review.coreboot.org/coreboot";
  # todo - extract from libreboot resources/coreboot/default/board.cfg
  rev = "b2e8bd83647f664260120fdfc7d07cba694dd89e"; # libreboot's rev
  hash = "sha256-1mDw+LrCspWUOYtGRVjXDYVsNHhFKUdSPmkLJou20Gg=";
  fetchSubmodules = true;
  leaveDotGit = true;
  postFetch = ''
    PATH=${lib.makeBinPath [ getopt ]}:$PATH ${stdenv.shell} $out/util/crossgcc/buildgcc -W > $out/.crossgcc_version
    rm -rf $out/.git
  '';
  allowedRequisites = [ ];
}


