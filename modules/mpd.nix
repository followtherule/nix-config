{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  cfg = config.local.mpd;
in
{
  options.local.mpd = {
    enable = mkEnableOption "mpd";
    port = mkOption {
      type = types.port;
      default = 6601;
    };
    dir = mkOption {
      type = types.path;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.local.users.media.group != null;
      }
    ];
    services.mpd = {
      enable = true;
      openFirewall = true;
      settings = {
        bind_to_address = "any";
        port = cfg.port;
        music_directory = cfg.dir;
        audio_output = [
          {
            type = "pipewire";
            name = "PipeWire Output";
          }
        ];
      };

      # Optional:
      startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
    };

    systemd.services.mpd.serviceConfig.SupplementaryGroups = [
      config.local.users.media.group
      "pipewire"
      "aria2"
    ];

    users.users.${config.services.mpd.user}.extraGroups = [
      config.local.users.media.group
      "pipewire"
      "aria2"
    ];
    # services.mpd.user = "mpd";
    # services.mpd.group = "pipewire";
    # systemd.services.mpd.environment = {
    #   # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
    #   XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.${config.services.mpd.user}.uid}"; # User-id must match above user. MPD will look inside this directory for the PipeWire socket.
    # };
  };
}
