{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.lidarr;
in
{
  options.local.lidarr = {
    enable = mkEnableOption "lidarr";
    port = mkOption {
      type = types.port;
      default = 8686;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.local.users.media.user != null;
      }
      {
        assertion = config.local.users.media.group != null;
      }
    ];
    services.lidarr = {
      enable = true;
      openFirewall = true;
      user = config.local.users.media.user;
      group = config.local.users.media.group;
      settings = {
        server.port = cfg.port;
      };
    };

    services.caddy.virtualHosts = {
      "lidarr.${domainName}" = mkIf config.local.caddy.enable {
        extraConfig = ''
          reverse_proxy localhost:${toString cfg.port}
        '';
        useACMEHost = "${domainName}";
      };
    };

    sops = {
      secrets = {
        "lidarr/url" = { };
        "lidarr/api_key" = { };
      };
    };
  };
}
