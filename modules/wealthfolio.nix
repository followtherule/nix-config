{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.wealthfolio;
in
{
  options.local.wealthfolio = {
    enable = mkEnableOption "wealthfolio";
    port = mkOption {
      type = types.port;
      default = 8088;
    };
  };

  config = mkIf cfg.enable {
    services.wealthfolio = {
      enable = true;
      port = cfg.port;
      address = "0.0.0.0";
      authPasswordHashFile = config.sops.secrets."wealthfolio/hash".path;
      corsAllowOrigins = "https://wealthfolio.${domainName}";
      # logFormat = "text"; # json
      openFirewall = true;
      secretKeyFile = config.sops.secrets."wealthfolio/key".path;
    };

    services.caddy = {
      enable = true;
      virtualHosts = {
        "wealthfolio.${domainName}" = {
          extraConfig = ''
            reverse_proxy localhost:${toString cfg.port}
          '';
          useACMEHost = "${domainName}";
        };
      };
    };

    sops = {
      secrets = {
        "wealthfolio/hash" = { };
        "wealthfolio/key" = { };
      };
    };
  };
}
