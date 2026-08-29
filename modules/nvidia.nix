{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  cfg = config.local.nvidia;
in
# seems like facter does not generate the proprietary NVIDIA kernel modules currently,
# and just remove noveau driver, so we configure it manually
# see https://github.com/nix-community/nixos-facter-modules/issues/72
# https://wiki.nixos.org/wiki/NVIDIA
# https://discourse.nixos.org/t/installing-nvidia-drivers-on-a-laptop-in-nixos/70951/2
{
  options.local.nvidia = {
    enable = mkEnableOption "nvidia";
  };

  config = mkIf cfg.enable {
    hardware.graphics.enable = true;

    services.xserver.videoDrivers = [
      "nvidia" # enable nvidia kerenl modules
      # "modesetting" # needed for offloading
    ];

    hardware.nvidia = {
      # Use the open source version of the kernel modules
      open = true;

      # Wayland requires kernel mode setting (KMS) to be enabled
      modesetting.enable = true;
    };
    nixpkgs.config.allowUnfree = true;
  };
}
