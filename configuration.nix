# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./sops.nix
  ];

  # move old root subvolume to /btrfs_tmp/old_roots, delete after 30 days, mount new blank root subvolume
  # boot.initrd.systemd = {
  #   enable = true; # this enabled systemd support in stage1 - required for the below setup
  #   services.rollback = {
  #     description = "mount the new blank root subvolume";
  #     wantedBy = [ "initrd.target" ];
  #
  #     # LUKS/TPM process. If you have named your device mapper something other
  #     # than 'enc', then @enc will have a different name. Adjust accordingly.
  #     # after = [ "systemd-cryptsetup@enc.service" ];
  #
  #     # Before mounting the system root (/sysroot) during the early boot process
  #     before = [ "sysroot.mount" ];
  #
  #     unitConfig.DefaultDependencies = "no";
  #     serviceConfig.Type = "oneshot";
  #     script = ''
  #       mkdir /btrfs_tmp
  #       mount /dev/disk/by-label/nixos /btrfs_tmp
  #       if [[ -e /btrfs_tmp/root ]]; then
  #           mkdir -p /btrfs_tmp/old_roots
  #           timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
  #           mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
  #       fi
  #
  #       delete_subvolume_recursively() {
  #           IFS=$'\n'
  #           for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
  #               delete_subvolume_recursively "/btrfs_tmp/$i"
  #           done
  #           btrfs subvolume delete "$1"
  #       }
  #
  #       for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
  #           delete_subvolume_recursively "$i"
  #       done
  #
  #       btrfs subvolume create /btrfs_tmp/root
  #       umount /btrfs_tmp
  #     '';
  #   };
  # };

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "tomori"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false; # needed for hashedPasswordFIle not conflict with initialPassword
  users.users.politecat = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      # tree
    ];
    # initialPassword = "12345";
    hashedPasswordFile = "/persist/passwd/politecat";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOGetBojxlWNeKwUfLdR0Q9RZ0oUTtWPghaxax/XZUWD politecat@archlinux"
    ];
  };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    mergerfs
    #   wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 69 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "politecat" ];
    };
  };
  services.fail2ban.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
