{ pkgs, config, ... }:

{
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/home/politecat/.config/sops/age/keys.txt";

  sops.secrets.example-key = { };
  sops.secrets."myservice/my_subdir/my_secret" = { };
}
