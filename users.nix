{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  # make /etc/passwd, /etc/group congruent to declarative configurations,
  # and avoid imperative command. needed for hashedPasswordFile not conflict with initialPassword
  users.mutableUsers = false;
  users.users.politecat = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      # "kvm"
      # "libvirtd"
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

  users.users.media = {
    isSystemUser = true;
    group = "media";
  };
  users.groups.media = { };
}
