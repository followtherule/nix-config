{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.vikunja;
in
{
  options.local.vikunja = {
    enable = mkEnableOption "vikunja";
    port = mkOption {
      type = types.port;
      default = 3456;
    };
  };

  config = mkIf cfg.enable {
    services.vikunja = {
      enable = true;
      address = "0.0.0.0";
      # database.type = "postgres";
      frontendHostname = "vikunja.${domainName}";
      frontendScheme = "https";
      # user = "vikunja";
      port = cfg.port;

      # see https://vikunja.io/docs/config-options
      # settings = {
      #   service = {
      #     # If enabled, Vikunja will send an email to everyone who is either
      #     # assigned to a task or created it when a task reminder is due.
      #     enableemailreminders = false;
      #     # Whether to let new users registering themselves or not
      #     enableregistration = false;
      #     # The maximum size clients will be able to request for user avatars.
      #     # If clients request a size bigger than this, it will be changed on the fly.
      #     maxavatarsize = 4096;
      #     # The duration of the issued JWT tokens in seconds.
      #     jwtttl = 2592000;
      #     # The duration of the "remember me" time in seconds. When the login request is
      #     # made with the long param set, the token returned will be valid for this period.
      #     jwtttllong = 25920000;
      #     maxitemsperpage = 100;
      #   };
      # };
    };

    services.caddy = {
      enable = true;
      virtualHosts = {
        "vikunja.${domainName}" = {
          extraConfig = ''
            reverse_proxy localhost:${toString cfg.port}
          '';
          useACMEHost = "${domainName}";
        };
      };
    };

    sops = {
      secrets = {
        "vikunja/url" = { };
        "vikunja/key" = { };
      };
    };
  };
}
