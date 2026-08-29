{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.sonarr;
in
{
  options.local.sonarr = {
    enable = mkEnableOption "sonarr";
    port = mkOption {
      type = types.port;
      default = 8989;
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
    services.sonarr = {
      enable = true;
      openFirewall = true;
      settings.server.port = cfg.port;
      user = config.local.users.media.user;
      group = config.local.users.media.group;
    };

    # Define the second Sonarr instance
    # systemd.services.sonarr-second = {
    #   description = "Sonarr (Second Instance)";
    #   after = [ "network.target" ];
    #   wantedBy = [ "multi-user.target" ];
    #
    #   serviceConfig = {
    #     Type = "simple";
    #     User = "sonarr"; # Or your specific media user
    #     Group = "sonarr";
    #     ExecStart = "${pkgs.sonarr}/bin/sonarr -nobrowser -data=/var/lib/sonarr-second";
    #     Restart = "on-failure";
    #   };
    # };

    services.caddy.virtualHosts = {
      "sonarr.${domainName}" = mkIf config.local.caddy.enable {
        extraConfig = ''
          reverse_proxy localhost:${toString cfg.port}
        '';
        useACMEHost = "${domainName}";
      };
    };

    sops = {
      secrets = {
        "sonarr/url" = { };
        "sonarr/api_key" = {
          mode = "0440";
          owner = config.local.users.media.user;
          group = config.local.users.media.group;
        };
      };
    };
  };
}
