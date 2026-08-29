{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.miniflux;
in
{
  options.local.miniflux = {
    enable = mkEnableOption "miniflux";
    port = mkOption {
      type = types.port;
      default = 8081;
    };
  };

  config = mkIf cfg.enable {
    services.miniflux = {
      enable = true;
      config = {
        LISTEN_ADDR = "127.0.0.1:${toString cfg.port}";
      };
      adminCredentialsFile = config.sops.templates.miniflux-env.path;
    };

    networking.firewall.allowedTCPPorts = [
      cfg.port
    ];

    sops = {
      templates.miniflux-env = {
        content = ''
          ADMIN_USERNAME="${config.sops.placeholder."miniflux/username"}"
          ADMIN_PASSWORD="${config.sops.placeholder."miniflux/password"}"
        '';
      };
    };

    services.caddy.virtualHosts = {
      "miniflux.${domainName}" = mkIf config.local.caddy.enable {
        extraConfig = ''
          reverse_proxy localhost:${toString cfg.port}
        '';
        useACMEHost = "${domainName}";
      };
    };

    sops = {
      secrets = {
        "miniflux/username" = { };
        "miniflux/password" = { };
      };
    };
  };
}
