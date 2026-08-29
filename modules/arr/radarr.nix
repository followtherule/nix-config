{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.radarr;
in
{
  options.local.radarr = {
    enable = mkEnableOption "radarr";
    port = mkOption {
      type = types.port;
      default = 7878;
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
    services.radarr = {
      enable = true;
      openFirewall = true;
      settings.server.port = cfg.port;
      user = config.local.users.media.user;
      group = config.local.users.media.group;
    };

    services.caddy.virtualHosts = {
      "radarr.${domainName}" = mkIf config.local.caddy.enable {
        extraConfig = ''
          reverse_proxy localhost:${toString cfg.port}
        '';
        useACMEHost = "${domainName}";
      };
    };

    sops = {
      secrets = {
        "radarr/url" = { };
        "radarr/api_key" = {
          mode = "0440";
          owner = config.local.users.media.user;
          group = config.local.users.media.group;
        };
      };
    };
  };
}
