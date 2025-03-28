{
  description = "Jerry's Nix Flake";
  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-24.11";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = { self, nixpkgs, home-manager, nix-vscode-extensions, 
  deploy-rs , 
  ... } @ inputs: let
    username = "jerry";
    inherit (self) outputs;
    inherit (inputs.nixpkgs.lib) nixosSystem;
    
    mkNixOSConfig = host: {
      specialArgs = { inherit inputs outputs username; };
      modules = [ 
        ./hosts/${host} 
        home-manager.nixosModules.home-manager
      ];
    };

    mkNixOSNode = hostname: {
      inherit hostname;
      profiles.system = {
        user = "root";
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.${hostname};
      };
    };

    forAllSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
    ];

  in {
   packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    nixosConfigurations = {
      jerry = nixosSystem (mkNixOSConfig "jerry");
    };

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    deploy = {
      modes = {
        jerry = mkNixOSNode "jerry";
      };
    };
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
