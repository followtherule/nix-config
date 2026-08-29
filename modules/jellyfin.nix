{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.jellyfin;
in
{
  options.local.jellyfin = {
    enable = mkEnableOption "jellyfin";
  };

  config = mkIf cfg.enable {
    services.jellyfin.enable = true;
    services.jellyfin.openFirewall = true; # 8096
    environment.systemPackages = [
      pkgs.jellyfin
      pkgs.jellyfin-web
      pkgs.jellyfin-ffmpeg
    ];

    services.caddy.virtualHosts = {
      "jellyfin.${domainName}" = mkIf config.local.caddy.enable {
        extraConfig = ''
          reverse_proxy localhost:8096
        '';
        useACMEHost = "${domainName}";
      };
    };

    sops = {
      secrets = {
        "jellyfin/url" = { };
        "jellyfin/api_key" = { };
      };
    };
  };
}
