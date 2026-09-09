{ stdenv, fetchurl, autoPatchelfHook, openssl, lib }:

stdenv.mkDerivation rec {
  pname = "sentinelle";
  version = "2.8.0";

  src = fetchurl {
    url = "https://github.com/nixos-le-systeme-declaratif/sentinelle"
      + "/releases/download/v${version}/sentinelle-linux-x86_64.tar.gz";
    hash = "sha256-039M53QV3mzA7a6vOn23ZkjDinPTwyedXvu/IbfsXhU=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ openssl stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall
    install -Dm755 sentinelle $out/bin/sentinelle
    runHook postInstall
  '';

  meta.license = lib.licenses.unfree;
}
