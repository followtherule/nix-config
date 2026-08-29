{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  cfg = config.local.neovim;
in
{
  options.local.neovim = {
    enable = mkEnableOption "neovim";
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
