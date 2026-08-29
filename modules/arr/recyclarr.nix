{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  cfg = config.local.recyclarr;
in
{
  options.local.recyclarr = {
    enable = mkEnableOption "recyclarr";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.local.users.media.user != null;
      }
      {
        assertion = config.local.users.media.group != null;
      }
      {
        assertion = config.local.radarr.enable;
      }
      {
        assertion = config.local.sonarr.enable;
      }
    ];
    services.recyclarr = {
      configuration = {
        radarr = {
          radarr-main = {
            api_key = {
              _secret = "/run/secrets/radarr/api_key";
            };
            base_url = "http://localhost:${toString config.local.radarr.port}";
            delete_old_custom_formats = true;
            quality_definition = {
              type = "movie";
            };
            quality_profiles = [
              {
                trash_id = "d1d67249d3890e49bc12e275d989a7e9"; # HD Bluray + WEB
                reset_unmatched_scores.enabled = true;
              }
              {
                trash_id = "64fb5f9858489bdac2af690e27c8f42f"; # UHD Bluray + WEB
                reset_unmatched_scores.enabled = true;
              }
              {
                trash_id = "9ca12ea80aa55ef916e3751f4b874151"; # Remux + WEB 1080p
                reset_unmatched_scores.enabled = true;
              }
              {
                trash_id = "fd161a61e3ab826d3a22d53f935696dd"; # Remux + WEB 2160p
                reset_unmatched_scores.enabled = true;
              }
              {
                trash_id = "722b624f9af1e492284c4bc842153a38"; # [Anime] Remux-1080p
                reset_unmatched_scores.enabled = true;
              }
            ];
            media_naming = {
              folder = "jellyfin-tmdb";
              movie = {
                rename = true;
                standard = "jellyfin-tmdb";
              };
            };
            custom_format_groups = {
              add = [
                {
                  trash_id = "f8bf8eab4617f12dfdbd16303d8da245"; # [Optional] Golden Rule HD
                  select = [
                    "dc98083864ea246d05a42df0d05f81cc" # x265 (HD)
                  ];
                }
                {
                  trash_id = "a3ac6af01d78e4f21fcb75f601ac96df"; # [Unwanted] Unwanted Formats
                  select = [
                    "b8cd450cbfa689c0259a01d9e29ba3d6" # 3D
                    "cae4ca30163749b891686f95532519bd" # AV1
                    "b6832f586342ef70d9c128d40c07b872" # Bad Dual Groups
                    "cc444569854e9de0b084ab2b8b1532b2" # Black and White Editions
                    "ed38b889b31be83fda192888e2286d83" # BR-DISK
                    "0a3f082873eb454bde444150b70253cc" # Extras
                    "e6886871085226c3da1830830146846c" # Generated Dynamic HDR
                    "90a6f9a284dff5103f6346090e6280c8" # LQ
                    "e204b80c87be9497a8a6eaff48f72905" # LQ (Release Title)
                    "712d74cd88bceb883ee32f773656b1f5" # Sing-Along Versions
                    "bfd8eb01832d646a0a89c4deb46f8564" # Upscaled
                  ];
                }
                {
                  trash_id = "7fc2751eef7e6bdc70b74136e5e35c76"; # [HDR Formats] DV (w/o HDR fallback)
                  assign_scores_to = [
                    {
                      trash_id = "d1d67249d3890e49bc12e275d989a7e9"; # HD Bluray + WEB
                    }
                    {
                      trash_id = "722b624f9af1e492284c4bc842153a38"; # [Anime] Remux-1080p
                    }
                  ];
                  select_all = true;
                }
                {
                  trash_id = "1616617ab3a14397a2b2321bcbda44d1"; # [HDR Formats] DV Boost
                  assign_scores_to = [
                    {
                      trash_id = "d1d67249d3890e49bc12e275d989a7e9"; # HD Bluray + WEB
                    }
                    {
                      trash_id = "722b624f9af1e492284c4bc842153a38"; # [Anime] Remux-1080p
                    }
                  ];
                  select_all = true;
                }
                {
                  trash_id = "ef20e67b95a381fb3bc6d1f06ea24f46"; # [HDR Formats] HDR
                  assign_scores_to = [
                    {
                      trash_id = "d1d67249d3890e49bc12e275d989a7e9"; # HD Bluray + WEB
                    }
                    {
                      trash_id = "722b624f9af1e492284c4bc842153a38"; # [Anime] Remux-1080p
                    }
                  ];
                  select_all = true;
                }
                {
                  trash_id = "b29413a7487478fe98228ce79e5689e4"; # [HDR Formats] HDR10+ Boost
                  assign_scores_to = [
                    {
                      trash_id = "d1d67249d3890e49bc12e275d989a7e9"; # HD Bluray + WEB
                    }
                    {
                      trash_id = "722b624f9af1e492284c4bc842153a38"; # [Anime] Remux-1080p
                    }
                  ];
                  select_all = true;
                }
              ];
            };
          };
        };

        sonarr = {
          sonarr-main = {
            api_key = {
              _secret = "/run/secrets/sonarr/api_key";
            };
            base_url = "http://localhost:${toString config.local.sonarr.port}";
            delete_old_custom_formats = true;
            quality_definition = {
              type = "series";
            };
            quality_profiles = [
              {
                trash_id = "72dae194fc92bf828f32cde7744e51a1"; # WEB-1080p
                reset_unmatched_scores.enabled = true;
              }
              {
                trash_id = "9d142234e45d6143785ac55f5a9e8dc9"; # WEB-1080p (Alternative)
                reset_unmatched_scores.enabled = true;
              }
              {
                trash_id = "d1498e7d189fbe6c7110ceaabb7473e6"; # WEB-2160p
                reset_unmatched_scores.enabled = true;
              }
              {
                trash_id = "dfa5eaae7894077ad6449169b6eb03e0"; # WEB-2160p (Alternative)
                reset_unmatched_scores.enabled = true;
              }
              {
                trash_id = "20e0fc959f1f1704bed501f23bdae76f"; # [Anime] Remux-1080p
                reset_unmatched_scores.enabled = true;
              }
            ];
            media_naming = {
              series = "jellyfin-tvdb";
              season = "default";
              episodes = {
                rename = true;
                standard = "default";
                daily = "default";
                anime = "default";
              };
            };
            custom_format_groups = {
              add = [
                {
                  trash_id = "158188097a58d7687dee647e04af0da3"; # [Optional] Golden Rule HD
                  select = [
                    "47435ece6b99a0b477caf360e79ba0bb" # x265 (HD)
                  ];
                }
                {
                  trash_id = "85fae4a2294965b75710ef2989c850eb"; # [Streaming Services] HD/UHD boost
                  select = [
                    "218e93e5702f44a68ad9e3c6ba87d2f0" # HD Streaming Boost
                    "43b3cf48cb385cd3eac608ee6bca7f09" # UHD Streaming Boost
                  ];
                }
                {
                  trash_id = "59c3af66780d08332fdc64e68297098f"; # [Unwanted] Unwanted Formats
                  select = [
                    "15a05bc7c1a36e2b57fd628f8977e2fc" # AV1
                    "32b367365729d530ca1c124a0b180c64" # Bad Dual Groups
                    "85c61753df5da1fb2aab6f2a47426b09" # BR-DISK
                    "6f808933a71bd9666531610cb8c059cc" # BR-DISK (BTN)
                    "fbcb31d8dabd2a319072b84fc0b7249c" # Extras
                    "9c11cd3f07101cdba90a2d81cf0e56b4" # LQ
                    "e2315f990da2e2cbfc9fa5b7a6fcfe48" # LQ (Release Title)
                    "23297a736ca77c0fc8e70f8edd7ee56c" # Upscaled
                  ];
                }
                {
                  trash_id = "d776a1ea912a117d66d83b880ff2055d"; # [HDR Formats] DV (w/o HDR fallback)
                  assign_scores_to = [
                    {
                      trash_id = "72dae194fc92bf828f32cde7744e51a1"; # WEB-1080p
                    }
                    {
                      trash_id = "9d142234e45d6143785ac55f5a9e8dc9"; # WEB-1080p (Alternative)
                    }
                    {
                      trash_id = "20e0fc959f1f1704bed501f23bdae76f"; # [Anime] Remux-1080p
                    }
                  ];
                  select_all = true;
                }
                {
                  trash_id = "e0b2774083df4265f25c9e5bc6c80940"; # [HDR Formats] DV Boost
                  assign_scores_to = [
                    {
                      trash_id = "72dae194fc92bf828f32cde7744e51a1"; # WEB-1080p
                    }
                    {
                      trash_id = "9d142234e45d6143785ac55f5a9e8dc9"; # WEB-1080p (Alternative)
                    }
                    {
                      trash_id = "20e0fc959f1f1704bed501f23bdae76f"; # [Anime] Remux-1080p
                    }
                  ];
                  select_all = true;
                }
                {
                  trash_id = "7e1724c5da59e7474803ad25be98f6a3"; # [HDR Formats] HDR
                  assign_scores_to = [
                    {
                      trash_id = "72dae194fc92bf828f32cde7744e51a1"; # WEB-1080p
                    }
                    {
                      trash_id = "9d142234e45d6143785ac55f5a9e8dc9"; # WEB-1080p (Alternative)
                    }
                    {
                      trash_id = "20e0fc959f1f1704bed501f23bdae76f"; # [Anime] Remux-1080p
                    }
                  ];
                  select_all = true;
                }
                {
                  trash_id = "7d366c213e5c23a052b157356fac1921"; # [HDR Formats] HDR10+ Boost
                  assign_scores_to = [
                    {
                      trash_id = "72dae194fc92bf828f32cde7744e51a1"; # WEB-1080p
                    }
                    {
                      trash_id = "9d142234e45d6143785ac55f5a9e8dc9"; # WEB-1080p (Alternative)
                    }
                    {
                      trash_id = "20e0fc959f1f1704bed501f23bdae76f"; # [Anime] Remux-1080p
                    }
                  ];
                  select_all = true;
                }
              ];
            };
          };
        };

      };
      enable = true;
      user = config.local.users.media.user;
      group = config.local.users.media.group;
    };
  };
}
