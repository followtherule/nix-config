{ pkgs, ... }:

{
  services.sonarr = {
    enable = true;
    openFirewall = true; # 8989
    user = "media";
    group = "media";
  };

  # Define the second Sonarr instance
  # systemd.services.sonarr-second = {
  #   description = "Sonarr (Second Instance)";
  #   after = [ "network.target" ];
  #   wantedBy = [ "multi-user.target" ];
  #
  #   serviceConfig = {
  #     Type = "simple";
  #     User = "sonarr"; # Or your specific media user
  #     Group = "media";
  #     ExecStart = "${pkgs.sonarr}/bin/sonarr -nobrowser -data=/var/lib/sonarr-second";
  #     Restart = "on-failure";
  #   };
  # };
}
