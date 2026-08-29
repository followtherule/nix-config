{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.vaultwarden;
in
{
  options.local.vaultwarden = {
    enable = mkEnableOption "vaultwarden";
    port = mkOption {
      type = types.port;
      default = 8222;
    };
  };

  config = mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;
      backupDir = "/var/local/vaultwarden/backup";
      # in order to avoid having  ADMIN_TOKEN in the nix store it can be also set with the help of an environment file
      # be aware that this file must be created by hand (or via secrets management like sops)
      environmentFile = config.sops.templates.vaultwarden-env.path;
      config = {
        # Refer to https://github.com/dani-garcia/vaultwarden/blob/main/.env.template
        DOMAIN = "https://vaultwarden.${domainName}";
        SIGNUPS_ALLOWED = false;

        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = cfg.port;
        ROCKET_LOG = "critical";

        # This example assumes a mailserver running on localhost,
        # thus without transport encryption.
        # If you use an external mail server, follow:
        #   https://github.com/dani-garcia/vaultwarden/wiki/SMTP-configuration
        # SMTP_HOST = "127.0.0.1";
        # SMTP_PORT = 25;
        # SMTP_SECURITY = off;
        #
        # SMTP_FROM = "admin@bitwarden.example.com";
        # SMTP_FROM_NAME = "example.com Bitwarden server";
      };
    };

    sops = {
      templates.vaultwarden-env = {
        content = ''
          ADMIN_TOKEN="${config.sops.placeholder."vaultwarden/admin_token"}"
        '';
      };
    };

    networking.firewall.allowedTCPPorts = [
      cfg.port
    ];

    services.caddy = {
      enable = true;
      virtualHosts = {
        "vaultwarden.${domainName}" = {
          extraConfig = ''
            reverse_proxy localhost:${toString cfg.port}
          '';
          useACMEHost = "${domainName}";
        };
      };
    };

    sops = {
      secrets = {
        "vaultwarden/admin_token" = { };
      };
    };
  };
}
