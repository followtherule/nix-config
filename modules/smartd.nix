{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  cfg = config.local.smartd;
in
{
  options.local.smartd = {
    enable = mkEnableOption "smartd";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.local.users.default.email != null;
      }
    ];
    environment.systemPackages = with pkgs; [
      smartmontools
    ];
    services.smartd = {
      enable = true;
      defaults.monitored = "-a -o on -n standby,q -s (S/../../7/02|L/../(01|15)/./04) -m ${config.local.users.default.email} -M test";
      # defaults.monitored = "-a -o on -n standby,q -s (S/../.././02|L/../../7/04)";
      # devices will be auto-detected
      # devices = [
      #   {
      #     device = "/dev/disk/by-id/...";
      #   }
      # ];
      notifications = {
        mail = {
          sender = config.local.hostName;
          recipient = config.local.users.default.email;
        };
        test = true;
      };
    };
  };
}
