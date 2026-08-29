{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.prowlarr;
in
{
  options.local.prowlarr = {
    enable = mkEnableOption "prowlarr";
    port = mkOption {
      type = types.port;
      default = 9696;
    };
  };

  config = mkIf cfg.enable {
    services.prowlarr = {
      enable = true;
      openFirewall = true;
      settings.server.port = cfg.port;
    };

    services.caddy.virtualHosts = {
      "prowlarr.${domainName}" = mkIf config.local.caddy.enable {
        extraConfig = ''
          reverse_proxy localhost:${toString cfg.port}
        '';
        useACMEHost = "${domainName}";
      };
    };

    sops = {
      secrets = {
        "prowlarr/url" = { };
        "prowlarr/api_key" = { };
      };
    };
  };
}
