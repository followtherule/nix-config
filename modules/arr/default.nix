{ lib, ... }:
with lib;
{
  imports = [
    ./bazarr.nix
    ./flaresolverr.nix
    ./lidarr.nix
    ./prowlarr.nix
    ./radarr.nix
    ./recyclarr.nix
    ./seerr.nix
    ./sonarr.nix
  ];

  local = {
    bazarr.enable = mkDefault true;
    flaresolverr.enable = mkDefault true;
    lidarr.enable = mkDefault true;
    prowlarr.enable = mkDefault true;
    radarr.enable = mkDefault true;
    recyclarr.enable = mkDefault true;
    seerr.enable = mkDefault true;
    sonarr.enable = mkDefault true;
  };
}
