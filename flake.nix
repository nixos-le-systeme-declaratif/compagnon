{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    # pour retrouver les versions que le livre imprime :
    # nixpkgs.url = "github:NixOS/nixpkgs/b3fe9581c9061c749abef42b6d4ee7b7c05c33fa";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, sops-nix }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ (import ./overlays/retouches.nix) ];
      };
    in {
      packages.x86_64-linux.tomate = pkgs.tomate;
      packages.x86_64-linux.mon-blog = pkgs.callPackage ./paquets/mon-blog.nix { };

      nixosConfigurations.atelier = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/atelier/configuration.nix
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          { system.configurationRevision = self.rev or self.dirtyRev or null; }
        ];
      };
      nixosConfigurations.vitrine = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/vitrine/configuration.nix
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          { system.configurationRevision = self.rev or self.dirtyRev or null; }
        ];
      };
    };
}
