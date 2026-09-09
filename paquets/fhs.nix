# un Linux classique de poche
{ buildFHSEnv }:

buildFHSEnv {
  name = "fhs";
  targetPkgs = pkgs: with pkgs; [ openssl zlib icu ];
  runScript = "bash";
}
