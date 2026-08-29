{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.kavita;
in
{
  options.local.kavita = {
    enable = mkEnableOption "kavita";
    port = mkOption {
      type = types.port;
      default = 5000;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.local.users.media.user != null;
      }
    ];
    services.kavita = {
      enable = true;
      user = config.local.users.media.user;
      tokenKeyFile = config.sops.secrets."kavita/token_key".path;
      settings = {
        Port = cfg.port;
      };
    };

    networking.firewall.allowedTCPPorts = [
      cfg.port
    ];

    services.caddy.virtualHosts = {
      "kavita.${domainName}" = mkIf config.local.caddy.enable {
        extraConfig = ''
          reverse_proxy localhost:${toString cfg.port}
        '';
        useACMEHost = "${domainName}";
      };
    };

    sops = {
      secrets = {
        "kavita/token_key" = { };
        "kavita/url" = { };
        "kavita/username" = { };
        "kavita/password" = { };
      };
    };
  };
}
