{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  cfg = config.local.msmtp;
in
{
  options.local.msmtp = {
    enable = mkEnableOption "msmtp";
    user = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.local.users.default.email != null;
      }
    ];
    # for zed enableMail, enable sendmailSetuidWrapper
    services.mail.sendmailSetuidWrapper.enable = true;

    programs.msmtp = {
      enable = true;
      setSendmail = true;
      defaults = {
        aliases = "/etc/aliases";
        port = 465;
        auth = "on";
        tls = "on";
        tls_starttls = "off";
      };
      accounts = {
        default = {
          host = "smtp.gmail.com";
          passwordeval = "${pkgs.coreutils}/bin/cat ${config.sops.secrets."msmtp/password".path}";
          user = cfg.user;
          from = config.local.users.default.email;
        };
      };
    };

    environment.etc.aliases.text = ''
      root: ${config.local.users.default.email}
    '';

    sops = {
      secrets = {
        "msmtp/password" = {
          mode = "0440";
          owner = config.local.users.default.user;
        };
      };
    };
  };
}
