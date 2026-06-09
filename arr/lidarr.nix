{
  services.lidarr = {
    enable = true;
    openFirewall = true; # 8686
    user = "media";
    group = "media";
  };
}
