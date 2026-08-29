{
  lib,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.actual;
in
{
  options.local.actual = {
    enable = mkEnableOption "actual";
    port = mkOption {
      type = types.port;
      default = 3000;
    };
  };

  config = mkIf cfg.enable {
    services.actual = {
      enable = true;
      # user = "";
      # group = "";
      openFirewall = true;
      # dataDir = "/var/lib/actual";

      # see https://actualbudget.org/docs/config
      settings = {
        port = cfg.port;
      };
    };

    services.caddy.virtualHosts = {
      "actual.${domainName}" = mkIf config.local.caddy.enable {
        extraConfig = ''
          reverse_proxy localhost:${toString cfg.port}
        '';
        useACMEHost = "${domainName}";
      };
    };
  };
}
