{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.deluge;
in
{
  options.local.deluge = {
    enable = mkEnableOption "deluge";
    port = mkOption {
      type = types.port;
      default = 8112;
    };
    vpn = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.local.users.media.group != null;
      }
    ];
    services.deluge = {
      enable = true;
      web = {
        enable = true;
        openFirewall = true;
        port = cfg.port;
      };
    };

    users.users.deluge = {
      extraGroups = [
        config.local.users.media.group
      ];
    };

    # binding deluged to network namespace
    systemd.services.deluged = mkIf (cfg.vpn && config.local.vpn.enable) {
      bindsTo = [ "netns@wg.service" ];
      requires = [
        "network-online.target"
        "wg.service"
      ];
      serviceConfig.NetworkNamespacePath = [ "/var/run/netns/wg" ];
    };

    # allowing delugeweb to access deluged in network namespace, a socket is necesarry
    systemd.sockets."proxy-to-deluged" = mkIf (cfg.vpn && config.local.vpn.enable) {
      enable = true;
      description = "Socket for Proxy to Deluge Daemon";
      listenStreams = [ "58846" ];
      wantedBy = [ "sockets.target" ];
    };

    # creating proxy service on socket, which forwards the same port from the root namespace to the isolated namespace
    systemd.services."proxy-to-deluged" = mkIf (cfg.vpn && config.local.vpn.enable) {
      enable = true;
      description = "Proxy to Deluge Daemon in Network Namespace";
      requires = [
        "deluged.service"
        "proxy-to-deluged.socket"
      ];
      after = [
        "deluged.service"
        "proxy-to-deluged.socket"
      ];
      unitConfig = {
        JoinsNamespaceOf = "deluged.service";
      };
      serviceConfig = {
        User = "deluge";
        Group = "deluge";
        ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=5min 127.0.0.1:58846";
        PrivateNetwork = "yes";
      };
    };

    services.caddy.virtualHosts = {
      "deluge.${domainName}" = mkIf config.local.caddy.enable {
        extraConfig = ''
          reverse_proxy localhost:${toString cfg.port}
        '';
        useACMEHost = "${domainName}";
      };
    };

    sops = {
      secrets = {
        "deluge/url" = { };
        "deluge/password" = { };
      };
    };
  };
}
