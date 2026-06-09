deploy:
  nixos-rebuild switch --flake . --sudo

boot:
  nixos-rebuild boot --flake . --sudo --show-trace

debug:
  nixos-rebuild switch --flake . --sudo --show-trace --verbose

list:
  nixos-rebuild list-generations

test:
  nixos-rebuild test --flake . --sudo

vm:
  nixos-rebuild build-vm --flake . --sudo

shell PKG:
  nix shell nixpkgs\#{{PKG}}

run PKG:
  nix run nixpkgs\#{{PKG}}

upd:
  nix flake update

history:
  nix profile history --profile /nix/var/nix/profiles/system

repl:
  nix repl -f flake:nixpkgs

clean:
  # remove all generations older than 7 days
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

gc:
  # garbage collect all unused nix store entries
  nix-collect-garbage --delete-old

