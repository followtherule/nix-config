{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  cfg = config.local.users;
in
{
  options.local.users = {
    enable = mkEnableOption "users";
    default = {
      user = mkOption {
        type = types.str;
      };
      homeDir = mkOption {
        type = types.str;
        default = "/home/${cfg.default.user}";
      };
      email = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      hashedPasswordFile = mkOption {
        type = types.path;
      };
      sshKey = mkOption {
        type = types.str;
      };
      timeZone = mkOption {
        type = types.str;
      };
    };
    media = {
      user = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      group = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
    };
  };

  config = mkIf cfg.enable {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    # make /etc/passwd, /etc/group congruent to declarative configurations,
    # and avoid imperative command. needed for hashedPasswordFile not conflict with initialPassword
    users.mutableUsers = false;
    users.users."${cfg.default.user}" = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # sudo
        "fuse"
        # "kvm"
        # "libvirtd"
      ]
      ++ optionals (cfg.media.group != null) [
        cfg.media.group
      ]
      ++ optionals (config.local.pipewire.enable) [
        "pipewire"
      ]
      ++ optionals (config.local.aria2.enable) [
        "aria2"
      ]
      ++ optionals (config.local.networking.enable) [
        "networkmanager"
      ];
      packages = with pkgs; [
        # tree
      ];
      # initialPassword = "12345";
      hashedPasswordFile = cfg.default.hashedPasswordFile;
      openssh.authorizedKeys.keys = [
        cfg.default.sshKey
      ];
    };

    users.users."${cfg.media.user}" = {
      isSystemUser = true;
      group = cfg.media.group;
      extraGroups = optionals config.local.aria2.enable [
        "aria2" # for user media to access files downlaoded by aria2
      ];
    };
    users.groups."${cfg.media.group}" = { };
  };
}
