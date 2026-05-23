{
  preservation = {
    enable = true;

    preserveAt."/persist" = {
      directories = [
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/systemd/coredump"
        "/var/lib/systemd/rfkill"
        "/var/lib/systemd/timers"
        "/var/lib/fprint"
        "/var/lib/fwupd"
        "/var/lib/libvirt"
        "/var/lib/power-profiles-daemon"
        {
          directory = "/var/lib/nixos";
          inInitrd = true;
        }
        "/etc/NetworkManager/system-connections"
        "/etc/secureboot"
        # {
        #   directory = "/var/lib/colord";
        #   user = "colord";
        #   group = "colord";
        #   mode = "u=rwx,g=rx,o=";
        # }

      ];

      files = [
        "/var/lib/systemd/random-seed"

        {
          file = "/etc/machine-id";
          inInitrd = true;
          how = "symlink";
        }
        {
          file = "/etc/ssh/ssh_host_ed25519_key";
          how = "symlink";
          configureParent = true;
        }
        "/etc/ssh/ssh_host_ed25519_key.pub"
        {
          file = "/etc/ssh/ssh_host_rsa_key";
          how = "symlink";
          configureParent = true;
        }
        "/etc/ssh/ssh_host_rsa_key.pub"
        "/var/lib/NetworkManager/secret_key"
        "/var/lib/NetworkManager/timestamps"
        # {
        #   file = "/var/keys/secret_file";
        #   parentDirectory = {
        #     mode = "u=rwx,g=,o=";
        #   };
        # }
        # {
        #  file = "/etc/ssh/ssh_host_rsa_key";
        #  how = "symlink";
        #  configureParent = true;
        # }
        # {
        #  file = "/etc/ssh/ssh_host_ed25519_key";
        #  how = "symlink";
        #  configureParent = true;
        # }
        # "/var/lib/usbguard/rules.conf"

        # creates a symlink on the volatile root
        # creates an empty directory on the persistent volume, i.e. /persistent/var/lib/systemd
        # does not create an empty file at the symlink's target (would require `createLinkTarget = true`)
        # {
        #   file = "/var/lib/systemd/random-seed";
        #   how = "symlink";
        #   inInitrd = true;
        #   configureParent = true;
        # }
      ];

      # Preserve user files
      users = {
        politecat = {
          directories = [
            "nix-config"
            "Downloads"
            "Music"
            "Pictures"
            "Documents"
            "Videos"
            # "VirtualBox VMs"
            {
              directory = ".gnupg";
              mode = "0700";
            }
            {
              directory = ".ssh";
              mode = "0700";
            }
            # {
            #   directory = ".nixops";
            #   mode = "0700";
            # }
            {
              directory = ".local/share/keyrings";
              mode = "0700";
            }
            ".local/share/direnv"
            ".local/state/nvim"
            ".local/state/nix"
            # ".config/syncthing"
            # ".config/Element"
            # ".local/state/wireplumber"
            # ".mozilla"
          ];

          files = [
            ".config/sops/age/keys.txt"
            # ".histfile"
          ];
        };
        root = {
          # specify user home when it is not `/home/${user}`
          home = "/root";
          directories = [
            {
              directory = ".ssh";
              mode = "0700";
            }
          ];
        };
      };
    };
  };

  # needed for preserve /etc/machine-id
  # see https://github.com/nix-community/preservation/issues/6
  systemd.services.systemd-machine-id-commit = {
    unitConfig.ConditionPathIsMountPoint = [
      ""
      "/state/etc/machine-id"
    ];
    serviceConfig.ExecStart = [
      ""
      "systemd-machine-id-setup --commit --root /state"
    ];
  };
}
