{ pkgs, ... }:

{
  services.jellyfin.enable = true;
  services.jellyfin.openFirewall = true; # 8096
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];
}
