{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    # pour retrouver les versions que le livre imprime :
    # nixpkgs.url = "github:NixOS/nixpkgs/b3fe9581c9061c749abef42b6d4ee7b7c05c33fa";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    site.url = "git+https://forge/camille/carnet.git";
    site.flake = false;
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, site, disko }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ (import ./overlays/retouches.nix) ];
      };
    in {
      packages.x86_64-linux.tomate = pkgs.tomate;
      packages.x86_64-linux.tomate-image = pkgs.dockerTools.buildLayeredImage {
        name = "tomate";
        tag  = "1.2.0";
        config.Entrypoint = [ "${self.packages.x86_64-linux.tomate}/bin/tomate" ];
      };
      packages.x86_64-linux.mon-blog = pkgs.callPackage ./paquets/mon-blog.nix { src = site; };

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
        specialArgs = { mon-blog = self.packages.x86_64-linux.mon-blog; };
        system = "x86_64-linux";
        modules = [
          ./machines/vitrine/configuration.nix
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          { system.configurationRevision = self.rev or self.dirtyRev or null; }
        ];
      };
      nixosConfigurations.essai = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/essai/configuration.nix
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          { system.configurationRevision = self.rev or self.dirtyRev or null; }
        ];
      };
      nixosConfigurations.granit = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/granit/configuration.nix
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          { system.configurationRevision = self.rev or self.dirtyRev or null; }
        ];
      };
      nixosConfigurations.jury = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/jury/configuration.nix
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          { system.configurationRevision = self.rev or self.dirtyRev or null; }
        ];
      };

      nixosConfigurations.secours = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./machines/secours/configuration.nix ];
      };

      checks.x86_64-linux = {
        web              = pkgs.testers.runNixOSTest ./tests/web.nix;
        web-acces-reseau = pkgs.testers.runNixOSTest ./tests/web-acces-reseau.nix;

        vitrine-se-construit = self.nixosConfigurations.vitrine.config.system.build.toplevel;
      };
    };
}
