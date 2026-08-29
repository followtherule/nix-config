# modules can be shared and configured by hosts
{ lib, ... }:
with lib;
{
  imports = [
    ./arr
    ./actual.nix
    ./aria2.nix
    ./caddy.nix
    ./deluge.nix
    ./gc.nix
    ./glance.nix
    ./glances.nix
    ./home-assistant.nix
    ./homepage.nix
    ./jellyfin.nix
    ./kavita.nix
    ./kernel.nix
    ./memos.nix
    ./miniflux.nix
    ./mpd.nix
    ./navidrome.nix
    ./neovim.nix
    ./networking.nix
    ./nextcloud.nix
    ./nvidia.nix
    ./pipewire.nix
    ./postgresql.nix
    ./preservation.nix
    ./samba.nix
    ./slskd.nix
    ./smartd.nix
    ./sops.nix
    ./ssh.nix
    ./tailscale.nix
    ./uptime-kuma.nix
    ./users.nix
    ./vaultwarden.nix
    ./vikunja.nix
    ./vpn.nix
    ./wealthfolio.nix
    ./zsh.nix
  ];

  config.local = {
    actual.enable = mkDefault true;
    aria2.enable = mkDefault true;
    caddy.enable = mkDefault true;
    deluge.enable = mkDefault true;
    gc.enable = mkDefault true;
    glance.enable = mkDefault true;
    glances.enable = mkDefault true;
    home-assistant.enable = mkDefault true;
    homepage.enable = mkDefault true;
    jellyfin.enable = mkDefault true;
    kavita.enable = mkDefault true;
    kernel.enable = mkDefault true;
    memos.enable = mkDefault true;
    miniflux.enable = mkDefault true;
    mpd.enable = mkDefault true;
    navidrome.enable = mkDefault true;
    neovim.enable = mkDefault true;
    networking.enable = mkDefault true;
    nextcloud.enable = mkDefault true;
    nvidia.enable = mkDefault true;
    pipewire.enable = mkDefault true;
    postgresql.enable = mkDefault true;
    preservation.enable = mkDefault true;
    samba.enable = mkDefault true;
    slskd.enable = mkDefault true;
    smartd.enable = mkDefault true;
    sops.enable = mkDefault true;
    ssh.enable = mkDefault true;
    tailscale.enable = mkDefault true;
    uptime-kuma.enable = mkDefault true;
    users.enable = mkDefault true;
    vaultwarden.enable = mkDefault true;
    vikunja.enable = mkDefault true;
    vpn.enable = mkDefault true;
    wealthfolio.enable = mkDefault true;
    zsh.enable = mkDefault true;
  };
}
