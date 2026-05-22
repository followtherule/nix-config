{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    preservation.url = "github:nix-community/preservation";
  };

  outputs = inputs: {
    nixosConfigurations.tomori = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        inputs.preservation.nixosModules.default
        ./configuration.nix
        ./preservation.nix
      ];
    };
  };
}
