{ stdenv, zola }:

stdenv.mkDerivation {
  pname = "mon-blog";
  version = "1.0";

  src = ../site;   # pas de fetcher : un chemin du dépôt suffit

  nativeBuildInputs = [ zola ];

  installPhase = ''
    zola build -o $out
  '';
}
