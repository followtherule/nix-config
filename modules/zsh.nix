{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  cfg = config.local.zsh;
in
{
  options.local.zsh = {
    enable = mkEnableOption "zsh";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      # shellAliases = {
      #   ll = "ls -l";
      #   edit = "sudo -e";
      #   update = "sudo nixos-rebuild switch";
      # };

      histSize = 10000;
      histFile = "$HOME/.zsh_history";
      setOptions = [
        "HIST_IGNORE_ALL_DUPS"
      ];
    };
    users.extraUsers."${config.local.users.default.user}" = {
      shell = pkgs.zsh;
    };

    programs.starship.enable = true;
  };
}
