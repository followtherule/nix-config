{
  lib,
  pkgs,
  options,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.memos;
in
{
  options.local.memos = {
    enable = mkEnableOption "memos";
    port = mkOption {
      type = types.port;
      default = 5230;
    };
  };

  config = mkIf cfg.enable {
    services.memos = {
      enable = true;
      settings = options.services.memos.settings.default // {
        # MEMOS_MODE = "prod";
        # MEMOS_ADDR = "127.0.0.1";
        MEMOS_PORT = "${toString cfg.port}";
        # MEMOS_DATA = config.services.memos.dataDir;
        # MEMOS_DRIVER = "sqlite";
        MEMOS_INSTANCE_URL = "http://localhost:${toString cfg.port}";
      };
      # openFirewall = true;
      # dataDir = "/var/lib/memos/";
    };

    networking.firewall.allowedTCPPorts = [
      cfg.port
    ];

    services.caddy.virtualHosts = {
      "memos.${domainName}" = mkIf config.local.caddy.enable {
        extraConfig = ''
          reverse_proxy localhost:${toString cfg.port}
        '';
        useACMEHost = "${domainName}";
      };
    };
  };
}
