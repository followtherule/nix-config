{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.slskd;
in
{
  options.local.slskd = {
    enable = mkEnableOption "slskd";
  };

  config = mkIf cfg.enable {
    services.slskd = {
      enable = true; # 5030
      environmentFile = "${config.sops.templates.slskd-env.path}";
      # user = "slskd";
      # group = "slskd";
      # settings = {
      #   web = {
      #     authentication = {
      #       api_keys = {
      #         homepage_widget = {
      #           key = config.sops.secrets."slskd/api_key";
      #           role = "readonly";
      #           cidr = "0.0.0.0/0";
      #         };
      #       };
      #     };
      #   };
      # };
    };

    sops = {
      templates.slskd-env = {
        content = ''
          SLSKD_SLSK_USERNAME="${config.sops.placeholder."slskd/slsk_username"}"
          SLSKD_SLSK_PASSWORD="${config.sops.placeholder."slskd/slsk_password"}"
          SLSKD_USERNAME="${config.sops.placeholder."slskd/username"}"
          SLSKD_PASSWORD="${config.sops.placeholder."slskd/password"}"
          SLSKD_API_KEY="${config.sops.placeholder."slskd/api_key"}"
        '';
      };
    };

    networking.firewall.allowedTCPPorts = [
      5030
      5031
      50300
    ];

    services.caddy = {
      enable = true;
      virtualHosts = {
        "slskd.${domainName}" = {
          extraConfig = ''
            reverse_proxy localhost:5030
          '';
          useACMEHost = "${domainName}";
        };
      };
    };

    sops = {
      secrets = {
        "slskd/url" = { };
        "slskd/api_key" = {
          mode = "0440";
          owner = "slskd";
        };
        "slskd/slsk_username" = {
          mode = "0440";
          owner = "slskd";
        };
        "slskd/slsk_password" = {
          mode = "0440";
          owner = "slskd";
        };
        # web ui username
        "slskd/username" = {
          mode = "0440";
          owner = "slskd";
        };
        # web ui passwd
        "slskd/password" = {
          mode = "0440";
          owner = "slskd";
        };
      };
    };
  };
}
