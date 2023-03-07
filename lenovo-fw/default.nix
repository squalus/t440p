{ stdenv
, fetchurl
, geteltorito
}: stdenv.mkDerivation rec {

  name = "lenono-fw-${version}";
  version = "2.56";

  src = fetchurl {
    url = "https://download.lenovo.com/pccbbs/mobiles/gluj44us.iso";
    hash = "sha256-5FYLr+hXxmlC5AuGBkizNlmbZrLtyOaTfjQ6zBY7M5A=";
  };

  nativeBuildInputs = [ geteltorito ];

  dontUnpack = true;
  dontBuild = true;
  installPhase = ''
    geteltorito $src > $out
  '';
}
