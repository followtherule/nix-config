{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.glances;
in
{
  options.local.glances = {
    enable = mkEnableOption "glances";
    port = mkOption {
      type = types.port;
      default = 61208;
    };
  };

  config = mkIf cfg.enable {
    services.glances = {
      enable = true;
      openFirewall = true;
      extraArgs = [
        "--webserver"
        # "--disable-webui"
      ];
      port = cfg.port;
    };

    services.caddy.virtualHosts = {
      "glances.${domainName}" = mkIf config.local.caddy.enable {
        extraConfig = ''
          reverse_proxy localhost:${toString cfg.port}
        '';
        useACMEHost = "${domainName}";
      };
    };

    sops = {
      secrets = {
        "glances/url" = { };
      };
    };
  };
}
