{
  services.bazarr = {
    enable = true;
    openFirewall = true; # 6767
    user = "media";
    group = "media";
  };
}
