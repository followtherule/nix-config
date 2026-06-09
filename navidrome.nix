{
  services.navidrome = {
    enable = true;
    settings.MusicFolder = "/data/media/music";
    settings.Address = "0.0.0.0";
    user = "media";
    group = "media";
    openFirewall = true; # 4533
  };

  systemd.services.navidrome.serviceConfig.BindReadOnlyPaths = [
    "/data/media-mom/music"
  ];
}
