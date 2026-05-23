{ config, ... }:

{
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  # sops private key to decrypt secrets
  sops.age.keyFile = "/home/politecat/.config/sops/age/keys.txt";

  # key attrs defined in sops file (secrets/secrets.yaml)
  # To edit secrets/secrets.yaml: sops secrets/secrets.yaml
  # To access secrets: cat /run/secrets/myservice/my_subdir/my_secret
  sops.secrets.example_key = { };
  sops.secrets."myservice/my_subdir/my_secret" = {
    # secrets owned by root by default
    # owner = config.users.users.politecat.name;
  };

  # example to make service access secret files
  # From https://github.com/vimjoyer/sops-nix-video
  # systemd.services."sometestservice" = {
  #   script = ''
  #     echo "
  #     Hey bro! I'm a service, and imma send this secure password:
  #     $(cat ${config.sops.secrets."myservice/my_subdir/my_secret".path})
  #     located in:
  #     ${config.sops.secrets."myservice/my_subdir/my_secret".path}
  #     to database and hack the mainframe
  #     " > /var/lib/sometestservice/testfile
  #   '';
  #   serviceConfig = {
  #     User = "sometestservice";
  #     WorkingDirectory = "/var/lib/sometestservice";
  #   };
  # };
  #
  # users.users.sometestservice = {
  #   home = "/var/lib/sometestservice";
  #   createHome = true;
  #   isSystemUser = true;
  #   group = "sometestservice";
  # };
  # users.groups.sometestservice = { };
}
