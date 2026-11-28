{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "obel-mono";
  version = "1.001";

  src = fetchzip {
    url = "https://typographic.systems/download/ObelMono-${version}-ttf.zip";
    hash = "sha256-9rnpFs9QKpBF9BpItYAEoGqXSlTSBOGx/w3Co3zT9yg=";
  };

  installPhase = ''
    install -Dm644 variable/*.ttf -t $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "Variable monospace typeface for code and terminals";
    homepage = "https://typographic.systems/obel-mono";
    license = licenses.ofl;
  };
}
