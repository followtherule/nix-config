{
  networking.hostName = "tomori"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  networking.interfaces.eth0.ipv4.addresses = [
    {
      address = "192.168.1.101";
      prefixLength = 24;
    }
  ];

  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
  ];
  networking.enableIPv6 = false;
  # disable ipv6 on single interface
  # boot.kernel.sysctl."net.ipv6.conf.eth0.disable_ipv6" = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Open ports in the firewall.
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  networking.firewall.checkReversePath = "loose";
  networking.networkmanager.dns = "systemd-resolved";
  services.resolved.enable = true;

  networking.firewall.allowedTCPPorts = [
    80
    443
    5201 # for iperf3
  ];
}
