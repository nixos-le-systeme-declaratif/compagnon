final: prev: {

  # le paquet maison entre dans pkgs — son correctif embarqué
  tomate = (final.callPackage ../paquets/tomate.nix { }).overrideAttrs (ancien: {
    patches = (ancien.patches or [ ]) ++ [
      (final.fetchpatch {
        url = "https://github.com/nixos-le-systeme-declaratif/tomate/commit/d53d0b0.patch";
        hash = "sha256-hoKLiAmUP4XbkZrK4Q4SSYDXXENsJ2PXYQ+JPcHvrbk=";
      })
    ];
  });

  # htop, avancé d'une version
  htop = prev.htop.overrideAttrs (ancien: rec {
    version = "3.5.2";
    src = prev.fetchFromGitHub {
      owner = "htop-dev";  repo = "htop";
      tag = version;
      hash = "sha256-YKv0ski+lT4nMsGou0KmvXTbyG4DZYSq4+TU7Ts2qfo=";
    };
  });

  # ripgrep, avancé d'une version — la seconde empreinte resservie
  ripgrep = prev.ripgrep.overrideAttrs (ancien: rec {
    version = "15.2.0";
    src = prev.fetchFromGitHub {
      owner = "BurntSushi";
      repo = "ripgrep";
      rev = version;
      hash = "sha256-BsSIbZwB6s8i3dDTRYJ1EdVbJmiO0oxcLu6qiYlPkOI=";
    };
    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit src;
      name = "ripgrep-${version}-vendor";
      hash = "sha256-AqizStE9ICd6mNDZWdeXg6dHuTiY+B0TNauQQYWUa84=";
    };
  });

  # sentinelle, le binaire de l'éditeur — réparé à la construction
  sentinelle = final.callPackage ../paquets/sentinelle.nix { };
}
