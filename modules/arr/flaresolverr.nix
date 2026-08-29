{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  cfg = config.local.flaresolverr;
in
{
  options.local.flaresolverr = {
    enable = mkEnableOption "flaresolverr";
    port = mkOption {
      type = types.port;
      default = 8191;
    };
  };

  config = mkIf cfg.enable {
    services.flaresolverr = {
      enable = true;
      openFirewall = true;
      port = cfg.port;
    };
  };
}
