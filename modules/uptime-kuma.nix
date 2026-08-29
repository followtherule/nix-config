{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.uptime-kuma;
in
{
  options.local.uptime-kuma = {
    enable = mkEnableOption "uptime-kuma";
    port = mkOption {
      type = types.port;
      default = 3001;
    };
  };

  config = mkIf cfg.enable {
    services.uptime-kuma = {
      enable = true;
      settings = {
        UPTIME_KUMA_HOST = "127.0.0.1";
        UPTIME_KUMA_PORT = cfg.port;
      };
    };

    networking.firewall.allowedTCPPorts = [
      cfg.port
    ];

    services.caddy = {
      enable = true;
      virtualHosts = {
        "uptime-kuma.${domainName}" = {
          extraConfig = ''
            reverse_proxy localhost:${toString cfg.port}
          '';
          useACMEHost = "${domainName}";
        };
      };
    };

    sops = {
      secrets = {
        "uptimekuma/url" = { };
        "uptimekuma/slug" = { };
      };
    };
  };
}
