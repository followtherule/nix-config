{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.bazarr;
in
{
  options.local.bazarr = {
    enable = mkEnableOption "bazarr";
    port = mkOption {
      type = types.port;
      default = 6767;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.local.users.media.user != null;
      }
      {
        assertion = config.local.users.media.group != null;
      }
    ];
    services.bazarr = {
      enable = true;
      openFirewall = true;
      listenPort = cfg.port;
      user = config.local.users.media.user;
      group = config.local.users.media.group;
    };

    services.caddy.virtualHosts = {
      "bazarr.${domainName}" = mkIf config.local.caddy.enable {
        extraConfig = ''
          reverse_proxy localhost:${toString cfg.port}
        '';
        useACMEHost = "${domainName}";
      };
    };

    sops = {
      secrets = {
        "bazarr/url" = { };
        "bazarr/api_key" = { };
      };
    };
  };
}
