{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  cfg = config.local.vpn;
in
{
  options.local.vpn = {
    enable = mkEnableOption "vpn";
    ipv4_cidr = mkOption {
      type = types.str;
    };
    configFile = mkOption {
      type = types.path;
    };
  };

  config = mkIf cfg.enable {
    # creating network namespace
    systemd.services."netns@" = {
      description = "%I network namespace";
      before = [ "network.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.iproute2}/bin/ip netns add %I";
        ExecStop = "${pkgs.iproute2}/bin/ip netns del %I";
      };
    };

    # setting up wireguard interface within network namespace
    systemd.services.wg = {
      description = "wg network interface";
      bindsTo = [ "netns@wg.service" ];
      requires = [ "network-online.target" ];
      after = [ "netns@wg.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart =
          with pkgs;
          writers.writeBash "wg-up" ''
            set -e
            ${iproute2}/bin/ip link add wg0 type wireguard
            ${iproute2}/bin/ip link set wg0 netns wg
            ${iproute2}/bin/ip -n wg address add ${cfg.ipv4_cidr} dev wg0
            # ${iproute2}/bin/ip -n wg -6 address add <ipv6 VPN addr/cidr> dev wg0
            ${iproute2}/bin/ip netns exec wg \
              ${wireguard-tools}/bin/wg setconf wg0 ${cfg.configFile}
            ${iproute2}/bin/ip -n wg link set wg0 up
            # need to set lo up as network namespace is started with lo down
            ${iproute2}/bin/ip -n wg link set lo up
            ${iproute2}/bin/ip -n wg route add default dev wg0
            # ${iproute2}/bin/ip -n wg -6 route add default dev wg0
          '';
        ExecStop =
          with pkgs;
          writers.writeBash "wg-down" ''
            ${iproute2}/bin/ip -n wg route del default dev wg0
            # ${iproute2}/bin/ip -n wg -6 route del default dev wg0
            ${iproute2}/bin/ip -n wg link del wg0
          '';
      };
    };
  };
}
