{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.caddy;
in
{
  options.local.caddy = {
    enable = mkEnableOption "caddy";
    dnsProvider = mkOption {
      type = types.str;
    };
    dnsTokenName = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.local.users.default.email != null;
      }
    ];

    services.caddy = {
      enable = true;
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = config.local.users.default.email;
      certs = {
        "${domainName}" = {
          domain = "*.${domainName}";
          group = "caddy";
          dnsProvider = cfg.dnsProvider;
          environmentFile = config.sops.templates.acme-env.path;
          reloadServices = [
            "prosody"
            "coturn"
            "nginx"
            "caddy"
            "dovecot2"
            "postfix"
          ];
          postRun = ''
            # set permission on dir
            ${pkgs.acl}/bin/setfacl -m \
            u:nginx:rx,u:turnserver:rx,u:prosody:rx,u:dovecot2:rx,u:postfix:rx \
            /var/lib/acme/${domainName}

            # set permission on key file
            ${pkgs.acl}/bin/setfacl -m \
            u:nginx:r,u:turnserver:r,u:prosody:r,u:dovecot2:r,u:postfix:r \
            /var/lib/acme/${domainName}/*.pem
          '';
        };
      };
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    sops = {
      secrets = {
        "${cfg.dnsProvider}/token" = { };
      };
      templates.acme-env = {
        content = ''
          "${cfg.dnsTokenName}"="${config.sops.placeholder."${cfg.dnsProvider}/token"}"
        '';
      };
    };
  };
}
