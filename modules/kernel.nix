{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  cfg = config.local.kernel;
in
{
  options.local.kernel = {
    enable = mkEnableOption "kernel";
  };

  config = mkIf cfg.enable {
    # use the latest kernel
    # boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
