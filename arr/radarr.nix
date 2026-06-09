{
  services.radarr = {
    enable = true;
    openFirewall = true; # 7878
    user = "media";
    group = "media";
  };
}
