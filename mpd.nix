{ config, ... }:

{
  # services.mpd = {
  #   enable = true;
  #   openFirewall = true; # 6600
  #   settings = {
  #     bind_to_address = "any";
  #     musicDirectory = "/data/media/music";
  #     audio_output = [
  #       {
  #         type = "pipewire";
  #         name = "My PipeWire Output";
  #       }
  #     ];
  #   };
  #
  #   # Optional:
  #   startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
  # };
  #
  # services.mpd.user = "politecat";
  # systemd.services.mpd.environment = {
  #   # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
  #   XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.politecat.uid}"; # User-id must match above user. MPD will look inside this directory for the PipeWire socket.
  # };
}
