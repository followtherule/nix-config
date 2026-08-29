{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  cfg = config.local.pipewire;
in
{
  options.local.pipewire = {
    enable = mkEnableOption "pipewire";
  };

  config = mkIf cfg.enable {
    # rtkit (optional, recommended) allows Pipewire to use the realtime scheduler for increased performance.
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true; # if not already enabled
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment the following
      #jack.enable = true;

      # for mpd to access pipewire socket
      systemWide = true;
    };

    # # Socket activation too slow for headless; start at boot instead.
    # services.pipewire.socketActivation = false;
    # # Start WirePlumber (with PipeWire) at boot.
    # systemd.user.services.wireplumber.wantedBy = [ "default.target" ];
    # users.users."".linger = true; # keep user services running
    # users.users."".extraGroups = [ "audio" ];
  };
}
