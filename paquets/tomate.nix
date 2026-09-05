{ stdenv, fetchFromGitHub, lib }:

stdenv.mkDerivation {
  pname = "tomate";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "nixos-le-systeme-declaratif";
    repo = "tomate";
    rev = "v1.2.0";
    hash = "sha256-aqbNALCTXqcvqqR2RaiZqqTx2sWzD2pdyXRXhTKCsoE=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Un minuteur Pomodoro pour le terminal";
    homepage = "https://github.com/nixos-le-systeme-declaratif/tomate";
    license = lib.licenses.mit;
  };
}
