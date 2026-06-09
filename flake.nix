{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    preservation.url = "github:nix-community/preservation";
    sops-nix.url = "github:Mic92/sops-nix";
    # sops-nix.url = "github:Mic92/sops-nix/c591bf665727040c6cc5cb409079acb22dcce33c";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    {
      nixosConfigurations.tomori = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          inputs.preservation.nixosModules.default
          inputs.sops-nix.nixosModules.sops
          inputs.nixos-hardware.nixosModules.common-cpu-amd
          # inputs.nixos-hardware.nixosModules.common-gpu-nvidia
          inputs.nixos-hardware.nixosModules.common-pc-ssd # enable fstrim
          ./configuration.nix
          ./preservation.nix
        ];
      };
    };
}
