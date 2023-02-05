{ stdenv, fetchurl, innoextract, me_cleaner }:
stdenv.mkDerivation {
  name = "t440p-me-blob";
  src = fetchurl {
    url = "https://web.archive.org/web/20211120031520/https://download.lenovo.com/pccbbs/mobiles/glrg22ww.exe";
    hash = "sha512-89ea7IBciwCUpAgb52s6ItMpxHmtGCEESbeswyNsz8SiED6qfFt5pIcr/Wme7eBH79Rt+wbcj0fjIW/CVGEpmA==";
  };
  unpackPhase = ''
    innoextract $src
  '';
  nativeBuildInputs = [ innoextract me_cleaner ];
  buildPhase = ''
    me_cleaner.py -r -t -O $out ./app/ME9.1_5M_Production.bin
  '';
  dontInstall = true;
}
