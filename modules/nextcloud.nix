{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.nextcloud;
in
{
  options.local.nextcloud = {
    enable = mkEnableOption "nextcloud";
    port = mkOption {
      type = types.port;
      default = 8080;
    };
    region = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.local.postgresql.enable;
      }
    ];
    # environment.etc."nextcloud-admin-pass".text = "PWD";
    services.nextcloud = {
      enable = true;
      hostName = "localhost";
      database.createLocally = true;
      config = {
        dbtype = "pgsql";
        adminpassFile = "${config.sops.secrets."nextcloud/adminpass".path}";
      };
      settings = {
        # Some sane defaults required to satisfy Nextcloud configuration check
        maintenance_window_start = 1;
        default_phone_region = cfg.region;
        log_type = "systemd";
        serverid = 0;
        trusted_domains = [
          "*.${domainName}"
        ];
      };
      # Instead of using pkgs.nextcloud34Packages.apps or similar,
      # we'll reference the package version specified in services.nextcloud.package
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps)
          news
          contacts
          calendar
          tasks
          ;
      };
      extraAppsEnable = true;

      autoUpdateApps.enable = true;
      package = pkgs.nextcloud33;
      # maxUploadSize = "1G";

      # Nextcloud’s data storage path. Will be services.nextcloud.home (/var/lib/nextcloud) by default.
      # datadir = config.services.nextcloud.home;
    };

    # sops = {
    # templates.nextcloud-env = {
    #   content = ''
    #     ${config.sops.placeholder."nextcloud/adminpass"}
    #   '';
    # };
    # };

    networking.firewall.allowedTCPPorts = [
      cfg.port
    ];

    services.caddy = {
      enable = true;
      virtualHosts = {
        "nextcloud.${domainName}" = {
          extraConfig = ''
            reverse_proxy localhost:${toString cfg.port}
          '';
          useACMEHost = "${domainName}";
        };
      };
    };

    services.nginx.virtualHosts."${config.services.nextcloud.hostName}".listen = [
      {
        addr = "127.0.0.1";
        port = cfg.port;
      }
    ];

    sops = {
      secrets = {
        "nextcloud/url" = { };
        "nextcloud/token" = { };
        "nextcloud/adminpass" = {
          mode = "0440";
          owner = "nextcloud";
        };
      };
    };
  };
}
