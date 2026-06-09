{ config, ... }:

{
  services.slskd = {
    enable = true; # 5030
    environmentFile = "${config.sops.templates.slskd-env.path}";
    # user = "slskd";
    # group = "slskd";
  };

  sops = {
    secrets = {
      "slskd/slsk_username" = {
        mode = "0440";
        owner = "slskd";
      };
      "slskd/slsk_passwd" = {
        mode = "0440";
        owner = "slskd";
      };
      # web ui username
      "slskd/username" = {
        mode = "0440";
        owner = "slskd";
      };
      # web ui passwd
      "slskd/passwd" = {
        mode = "0440";
        owner = "slskd";
      };
    };
    templates.slskd-env = {
      content = ''
        SLSKD_SLSK_USERNAME="${config.sops.placeholder."slskd/slsk_username"}"
        SLSKD_SLSK_PASSWORD="${config.sops.placeholder."slskd/slsk_passwd"}"
        SLSKD_USERNAME="${config.sops.placeholder."slskd/username"}"
        SLSKD_PASSWORD="${config.sops.placeholder."slskd/passwd"}"
      '';
    };
  };

}
