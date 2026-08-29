{
  lib,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.navidrome;
in
{
  options.local.navidrome = {
    enable = mkEnableOption "navidrome";
    port = mkOption {
      type = types.port;
      default = 4533;
    };
    dir = mkOption {
      type = types.path;
    };
    dir2 = mkOption {
      type = types.path;
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
    services.navidrome = {
      enable = true;
      settings = {
        MusicFolder = cfg.dir;
        Address = "0.0.0.0";
        Port = cfg.port;
      };
      user = config.local.users.media.user;
      group = config.local.users.media.group;
      openFirewall = true;
    };

    systemd.services.navidrome.serviceConfig.BindReadOnlyPaths = [
      cfg.dir2
    ];

    services.caddy = {
      enable = true;
      virtualHosts = {
        "navidrome.${domainName}" = {
          extraConfig = ''
            reverse_proxy localhost:${toString cfg.port}
          '';
          useACMEHost = "${domainName}";
        };
      };
    };

    sops = {
      secrets = {
        "navidrome/url" = { };
        "navidrome/user" = { };
        "navidrome/token" = { };
        "navidrome/salt" = { };
      };
    };
  };
}
