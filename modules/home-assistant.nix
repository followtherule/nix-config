{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.home-assistant;
in
{
  options.local.home-assistant = {
    enable = mkEnableOption "home-assistant";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.local.postgresql.enable;
      }
    ];
    services.home-assistant = {
      enable = true;
      extraComponents = [
        # Components required to complete the onboarding
        "analytics"
        "google_translate"
        "met"
        "radio_browser"
        "shopping_list"
        # Recommended for fast zlib compression
        # https://www.home-assistant.io/integrations/isal
        "isal"
      ];
      extraPackages = ps: with ps; [ psycopg2 ];

      config = {
        # Includes dependencies for a basic setup
        # https://www.home-assistant.io/integrations/default_config/
        default_config = { };
        recorder.db_url = "postgresql://@/hass";
        http = {
          trusted_proxies = [
            "127.0.0.1"
            "::1"
          ];
          use_x_forwarded_for = true;
        };
      };
    };

    services.postgresql = {
      ensureDatabases = [ "hass" ];
      ensureUsers = [
        {
          name = "hass";
          ensureDBOwnership = true;
        }
      ];
    };

    networking.firewall.allowedTCPPorts = [
      8123
      # config.services.home-assistant.config.http.server_port
    ];

    services.caddy = {
      enable = true;
      virtualHosts = {
        "home-assistant.${domainName}" = {
          extraConfig = ''
            reverse_proxy localhost:8123
          '';
          useACMEHost = "${domainName}";
        };
      };
    };
  };
}
