{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  cfg = config.local.tailscale;
in
{
  options.local.tailscale = {
    enable = mkEnableOption "tailscale";
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      # Enable tailscale at startup

      # If you would like to use a preauthorized key
      #authKeyFile = "/run/secrets/tailscale_key";
    };
  };
}
