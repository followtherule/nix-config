{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.seerr;
in
{
  options.local.seerr = {
    enable = mkEnableOption "seerr";
    port = mkOption {
      type = types.port;
      default = 5055;
    };
  };

  config = mkIf cfg.enable {
    services.seerr = {
      enable = true;
      openFirewall = true;
      port = cfg.port;
    };

    services.caddy.virtualHosts = {
      "seerr.${domainName}" = mkIf config.local.caddy.enable {
        extraConfig = ''
          reverse_proxy localhost:${toString cfg.port}
        '';
        useACMEHost = "${domainName}";
      };
    };

    sops = {
      secrets = {
        "seerr/url" = { };
        "seerr/api_key" = { };
      };
    };
  };
}
