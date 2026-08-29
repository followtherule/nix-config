{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  cfg = config.local.postgresql;
in
{
  options.local.postgresql = {
    enable = mkEnableOption "postgresql";
  };

  config = mkIf cfg.enable {
    services.postgresql = {
      enable = true;
    };
  };
}
