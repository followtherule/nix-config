{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    preservation.url = "github:nix-community/preservation";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: {
    nixosConfigurations.tomori = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        inputs.preservation.nixosModules.default
        inputs.sops-nix.nixosModules.sops
        ./configuration.nix
        ./preservation.nix
      ];
    };
  };
}
