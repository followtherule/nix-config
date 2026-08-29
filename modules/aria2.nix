{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.aria2;
in
{
  options.local.aria2 = {
    enable = mkEnableOption "aria2";
    downloadDir = mkOption {
      type = types.singleLineStr;
    };
    port = mkOption {
      type = types.port;
      default = 6800;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.local.users.media.group != null;
      }
    ];
    environment.systemPackages = with pkgs; [
      aria2
      ariang
    ];
    services.aria2 = {
      enable = true;
      serviceUMask = "0002"; # file mode creation mask, make users in group aria2 (e.g. media) to read/write new downloaded files
      openPorts = true; # open listen-port and rpc-listen-port
      rpcSecretFile = "/run/secrets/aria2/rpc_token";
      # see https://aria2.github.io/manual/en/html/aria2c.html#synopsis
      settings = {
        # listen-port = [
        #   {
        #     from = 6881;
        #     to = 6999;
        #   }
        # ];
        continue = true;
        # daemon = true;
        dir = cfg.downloadDir;
        file-allocation = "falloc";
        log-level = "warn";
        max-connection-per-server = 4;
        max-concurrent-downloads = 3;
        max-overall-download-limit = 0;
        min-split-size = "5M";
        enable-http-pipelining = true;

        enable-rpc = true;
        rpc-listen-all = true;
        disable-ipv6 = true;
        rpc-allow-origin-all = true;
        rpc-listen-port = cfg.port;
        # rpc-secret=secret
      };
    };

    users.users.aria2 = {
      extraGroups = [
        config.local.users.media.group # for aria2 to add files in folders owned by the group users.media.group
      ];
    };

    services.caddy.virtualHosts = {
      "ariang.${domainName}" = mkIf config.local.caddy.enable {
        extraConfig = ''
          file_server {
            root ${pkgs.ariang}/share/ariang
          }
          reverse_proxy /jsonrpc localhost:${toString config.services.aria2.settings.rpc-listen-port}
        '';
        useACMEHost = "${domainName}";
      };
    };

    sops = {
      secrets = {
        "aria2/rpc_token" = { };
      };
    };
  };
}
