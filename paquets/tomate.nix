{ stdenv, fetchFromGitHub, lib }:

stdenv.mkDerivation {
  pname = "tomate";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "nixos-le-systeme-declaratif";
    repo = "tomate";
    rev = "v1.2.1";
    hash = "sha256-Mt2WdkrPhb4J/2slkhc4kVifouYM1GIRUEwfhHflEzk=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Un minuteur Pomodoro pour le terminal";
    homepage = "https://github.com/nixos-le-systeme-declaratif/tomate";
    license = lib.licenses.mit;
  };
}
