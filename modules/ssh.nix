{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  cfg = config.local.ssh;
in
{
  options.local.ssh = {
    enable = mkEnableOption "ssh";
    port = mkOption {
      type = types.port;
      default = 22;
    };
  };

  config = mkIf cfg.enable {
    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      ports = [ cfg.port ];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [ "${config.local.users.default.user}" ];
      };
    };
    services.fail2ban.enable = true;
  };
}
