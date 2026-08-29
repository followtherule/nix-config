{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  cfg = config.local.networking;
in
{
  options.local.networking = {
    enable = mkEnableOption "networking";
    hostName = mkOption {
      type = types.str;
    };
    ipv4 = mkOption {
      type = types.str;
    };
    defaultGateway = mkOption {
      type = types.str;
    };
    domainName = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    networking.hostName = cfg.hostName; # Define your hostname.

    # Configure network connections interactively with nmcli or nmtui.
    networking.networkmanager.enable = true;
    networking.interfaces.eth0.ipv4.addresses = [
      {
        address = cfg.ipv4;
        prefixLength = 24;
      }
    ];

    networking.defaultGateway = cfg.defaultGateway;
    networking.nameservers = [
      cfg.defaultGateway
      # "1.1.1.1"
      # "8.8.8.8"
    ];
    networking.enableIPv6 = false;
    # disable ipv6 on single interface
    # boot.kernel.sysctl."net.ipv6.conf.eth0.disable_ipv6" = true;

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Open ports in the firewall.
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    networking.firewall.checkReversePath = "loose";
    networking.networkmanager.dns = "systemd-resolved";
    services.resolved.enable = true;

    networking.firewall.allowedTCPPorts = [
      5201 # for iperf3
    ];
  };
}
