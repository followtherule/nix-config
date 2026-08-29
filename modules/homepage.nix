{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.homepage;
in
# icons can be found at https://dashboardicons.com/
{
  options.local.homepage = {
    enable = mkEnableOption "homepage";
    port = mkOption {
      type = types.port;
      default = 8082;
    };
  };

  config = mkIf cfg.enable {
    services.homepage-dashboard = {
      enable = true;
      openFirewall = true;
      allowedHosts = "localhost:${toString cfg.port},127.0.0.1:${toString cfg.port},homepage.${toString domainName}";
      environmentFiles = [ config.sops.templates.homepage-env.path ];

      # bookmarks = [{
      #   dev = [
      #     {
      #       github = [{
      #         abbr = "GH";
      #         href = "https://github.com/";
      #         icon = "github-light.png";
      #       }];
      #     }
      #     {
      #       "homepage docs" = [{
      #         abbr = "HD";
      #         href = "https://gethomepage.dev";
      #         icon = "homepage.png";
      #       }];
      #     }
      #   ];
      #   machines = [
      #     {
      #       tower = [{
      #         abbr = "TR";
      #         href = "https://dash.crgrd.uk";
      #         icon = "homarr.png";
      #       }];
      #     }
      #     {
      #       gbox = [{
      #         abbr = "GB";
      #         href = "https://dash.gbox.crgrd.uk";
      #         icon = "homepage.png";
      #       }];
      #     }
      #   ];
      # }];
      bookmarks = [
        {
          Finance = [
            {
              "yahoo finance" = [
                {
                  href = "https://finance.yahoo.com/";
                  icon = "yahoo.png";
                  # description = "";
                }
              ];
            }
          ];
        }
      ];
      services = [
        {
          Media = [
            {
              Radarr = {
                icon = "radarr.png";
                href = "{{HOMEPAGE_VAR_RADARR_URL}}";
                description = "film management";
                widget = {
                  type = "radarr";
                  url = "{{HOMEPAGE_VAR_RADARR_URL}}";
                  key = "{{HOMEPAGE_VAR_RADARR_API_KEY}}";
                };
              };
            }
            {
              Sonarr = {
                icon = "sonarr.png";
                href = "{{HOMEPAGE_VAR_SONARR_URL}}";
                description = "tv management";
                widget = {
                  type = "sonarr";
                  url = "{{HOMEPAGE_VAR_SONARR_URL}}";
                  key = "{{HOMEPAGE_VAR_SONARR_API_KEY}}";
                };
              };
            }
            {
              Prowlarr = {
                icon = "prowlarr.png";
                href = "{{HOMEPAGE_VAR_PROWLARR_URL}}";
                description = "index management";
                widget = {
                  type = "prowlarr";
                  url = "{{HOMEPAGE_VAR_PROWLARR_URL}}";
                  key = "{{HOMEPAGE_VAR_PROWLARR_API_KEY}}";
                };
              };
            }
            {
              Bazarr = {
                icon = "bazarr.png";
                href = "{{HOMEPAGE_VAR_BAZARR_URL}}";
                description = "subtitle management";
                widget = {
                  type = "bazarr";
                  url = "{{HOMEPAGE_VAR_BAZARR_URL}}";
                  key = "{{HOMEPAGE_VAR_BAZARR_API_KEY}}";
                };
              };
            }
            {
              Lidarr = {
                icon = "lidarr.png";
                href = "{{HOMEPAGE_VAR_LIDARR_URL}}";
                description = "music management";
                widget = {
                  type = "lidarr";
                  url = "{{HOMEPAGE_VAR_LIDARR_URL}}";
                  key = "{{HOMEPAGE_VAR_LIDARR_API_KEY}}";
                };
              };
            }
            {
              Slskd = {
                icon = "slskd.png";
                href = "{{HOMEPAGE_VAR_SLSKD_URL}}";
                description = "soulseek file-sharing network";
                widget = {
                  type = "slskd";
                  url = "{{HOMEPAGE_VAR_SLSKD_URL}}";
                  key = "{{HOMEPAGE_VAR_SLSKD_API_KEY}}";
                };
              };
            }
            #   {
            #     Sabnzbd = {
            #       icon = "sabnzbd.png";
            #       href = "{{HOMEPAGE_VAR_SABNZBD_URL}}/";
            #       description = "download client";
            #       widget = {
            #         type = "sabnzbd";
            #         url = "{{HOMEPAGE_VAR_SABNZBD_URL}}";
            #         key = "{{HOMEPAGE_VAR_SABNZBD_API_KEY}}";
            #       };
            #     };
            #   }
          ];
        }
        {
          Services = [
            {
              Jellyfin = {
                icon = "jellyfin.png";
                href = "{{HOMEPAGE_VAR_JELLYFIN_URL}}";
                description = "media management";
                widget = {
                  type = "jellyfin";
                  url = "{{HOMEPAGE_VAR_JELLYFIN_URL}}";
                  key = "{{HOMEPAGE_VAR_JELLYFIN_API_KEY}}";
                };
              };
            }
            {
              Seerr = {
                icon = "seerr.png";
                href = "{{HOMEPAGE_VAR_SEERR_URL}}";
                description = "media request and discovery manager";
                widget = {
                  type = "seerr";
                  url = "{{HOMEPAGE_VAR_SEERR_URL}}";
                  key = "{{HOMEPAGE_VAR_SEERR_API_KEY}}";
                };
              };
            }
            {
              Nextcloud = {
                icon = "nextcloud.png";
                href = "{{HOMEPAGE_VAR_NEXTCLOUD_URL}}";
                description = "A safe home for all your data";
                widget = {
                  type = "nextcloud";
                  url = "{{HOMEPAGE_VAR_NEXTCLOUD_URL}}";
                  key = "{{HOMEPAGE_VAR_NEXTCLOUD_TOKEN}}";
                };
              };
            }
            {
              Navidrome = {
                icon = "navidrome.png";
                href = "{{HOMEPAGE_VAR_NAVIDROME_URL}}";
                description = "music streaming service";
                widget = {
                  type = "navidrome";
                  url = "{{HOMEPAGE_VAR_NAVIDROME_URL}}";
                  user = "{{HOMEPAGE_VAR_NAVIDROME_USER}}";
                  token = "{{HOMEPAGE_VAR_NAVIDROME_TOKEN}}";
                  salt = "{{HOMEPAGE_VAR_NAVIDROME_SALT}}";
                };
              };
            }
            {
              OPNsense = {
                icon = "opnsense.png";
                href = "{{HOMEPAGE_VAR_OPNSENSE_URL}}";
                description = "firewall and routing platform";
                widget = {
                  type = "opnsense";
                  url = "{{HOMEPAGE_VAR_OPNSENSE_URL}}";
                  username = "{{HOMEPAGE_VAR_OPNSENSE_USERNAME}}";
                  password = "{{HOMEPAGE_VAR_OPNSENSE_PASSWORD}}";
                };
              };
            }
            # {
            #   "Uptime Kuma" = {
            #     icon = "uptime-kuma.png";
            #     href = "{{HOMEPAGE_VAR_UPTIMEKUMA_URL}}";
            #     description = "monitoring tool";
            #     widget = {
            #       type = "uptimekuma";
            #       url = "{{HOMEPAGE_VAR_UPTIMEKUMA_URL}}";
            #       slug = "{{HOMEPAGE_VAR_UPTIMEKUMA_SLUG}}";
            #     };
            #   };
            # }
            {
              Deluge = {
                icon = "deluge.png";
                href = "{{HOMEPAGE_VAR_DELUGE_URL}}";
                description = "BitTorrent client";
                widget = {
                  type = "deluge";
                  url = "{{HOMEPAGE_VAR_DELUGE_URL}}";
                  password = "{{HOMEPAGE_VAR_DELUGE_PASSWORD}}";
                  enableLeechProgress = true;
                };
              };
            }
            {
              Kavita = {
                icon = "kavita.png";
                href = "{{HOMEPAGE_VAR_KAVITA_URL}}";
                description = "reading server";
                widget = {
                  type = "kavita";
                  url = "{{HOMEPAGE_VAR_KAVITA_URL}}";
                  username = "{{HOMEPAGE_VAR_KAVITA_USERNAME}}";
                  password = "{{HOMEPAGE_VAR_KAVITA_PASSWORD}}";
                  enableLeechProgress = true;
                };
              };
            }
            {
              Vikunja = {
                icon = "vikunja.png";
                href = "{{HOMEPAGE_VAR_VIKUNJA_URL}}";
                description = "task manager";
                widget = {
                  type = "vikunja";
                  url = "{{HOMEPAGE_VAR_VIKUNJA_URL}}";
                  key = "{{HOMEPAGE_VAR_VIKUNJA_KEY}}";
                  enableTaskList = true;
                  version = 2;
                };
              };
            }
          ];
        }
        {
          System = [
            {
              "System Info" = {
                widget = {
                  type = "glances";
                  url = "{{HOMEPAGE_VAR_GLANCES_URL}}";
                  metric = "info";
                  version = 4;
                };
              };
            }
            {
              "CPU Usage" = {
                widget = {
                  type = "glances";
                  url = "{{HOMEPAGE_VAR_GLANCES_URL}}";
                  metric = "cpu";
                  version = 4;
                  cputemp = true;
                  refreshInterval = 5000;
                  # pointsLimit = 15;
                  # username = "user";
                  # password = "pass";
                };
              };
            }
            {
              "Network Usage" = {
                widget = {
                  type = "glances";
                  url = "{{HOMEPAGE_VAR_GLANCES_URL}}";
                  metric = "network:eth0";
                  version = 4;
                };
              };
            }
            {
              "Memory Usage" = {
                widget = {
                  type = "glances";
                  url = "{{HOMEPAGE_VAR_GLANCES_URL}}";
                  metric = "memory";
                  version = 4;
                };
              };
            }
            {
              "Process" = {
                widget = {
                  type = "glances";
                  url = "{{HOMEPAGE_VAR_GLANCES_URL}}";
                  metric = "process";
                  version = 4;
                };
              };
            }
            {
              "Disk IO (nvme0n1)" = {
                widget = {
                  type = "glances";
                  url = "{{HOMEPAGE_VAR_GLANCES_URL}}";
                  metric = "disk:nvme0n1";
                  version = 4;
                };
              };
            }
            {
              "Disk IO (sda)" = {
                widget = {
                  type = "glances";
                  url = "{{HOMEPAGE_VAR_GLANCES_URL}}";
                  metric = "disk:sda";
                  version = 4;
                };
              };
            }
            {
              "Disk IO (sdb)" = {
                widget = {
                  type = "glances";
                  url = "{{HOMEPAGE_VAR_GLANCES_URL}}";
                  metric = "disk:sdb";
                  version = 4;
                };
              };
            }
            # {
            #   Vaultwarden = {
            #     icon = "nextcloud.png";
            #     href = "{{HOMEPAGE_VAR_NEXTCLOUD_URL}}";
            #     description = "A safe home for all your data";
            #     widget = {
            #       type = "nextcloud";
            #       url = "{{HOMEPAGE_VAR_NEXTCLOUD_URL}}";
            #       key = "{{HOMEPAGE_VAR_NEXTCLOUD_API_KEY}}";
            #     };
            #   };
            # }
          ];
        }
        # {
        #   infra = [
        #     {
        #       Files = {
        #         description = "file manager";
        #         icon = "files.png";
        #         href = "https://files.jnsgr.uk";
        #       };
        #     }
        #     {
        #       "Syncthing (thor)" = {
        #         description = "syncthing ui for thor";
        #         icon = "syncthing.png";
        #         href = "https://thor.sync.jnsgr.uk";
        #       };
        #     }
        #     {
        #       "Syncthing (kara)" = {
        #         description = "syncthing ui for kara";
        #         icon = "syncthing.png";
        #         href = "https://kara.sync.jnsgr.uk";
        #       };
        #     }
        #     {
        #       "Syncthing (freyja)" = {
        #         description = "syncthing ui for freyja";
        #         icon = "syncthing.png";
        #         href = "https://freyja.sync.jnsgr.uk";
        #       };
        #     }
        #   ];
        # }
        # {
        #   machines = [
        #     {
        #       thor = {
        #         description = "thor";
        #         icon = "tailscale.png";
        #         href = "https://dash.jnsgr.uk";
        #         widget = {
        #           type = "tailscale";
        #           deviceid = "{{HOMEPAGE_VAR_TAILSCALE_THOR_DEVICE_ID}}";
        #           key = "{{HOMEPAGE_VAR_TAILSCALE_AUTH_KEY}}";
        #         };
        #       };
        #     }
        #     {
        #       tower = {
        #         description = "tower";
        #         icon = "tailscale.png";
        #         href = "https://dash.crgrd.uk";
        #         widget = {
        #           type = "tailscale";
        #           deviceid = "{{HOMEPAGE_VAR_TAILSCALE_TOWER_DEVICE_ID}}";
        #           key = "{{HOMEPAGE_VAR_TAILSCALE_AUTH_KEY}}";
        #         };
        #       };
        #     }
        #     {
        #       gbox = {
        #         description = "gbox";
        #         icon = "tailscale.png";
        #         href = "https://dash.gbox.crgrd.uk";
        #         widget = {
        #           type = "tailscale";
        #           deviceid = "{{HOMEPAGE_VAR_TAILSCALE_GBOX_DEVICE_ID}}";
        #           key = "{{HOMEPAGE_VAR_TAILSCALE_AUTH_KEY}}";
        #         };
        #       };
        #     }
        #     {
        #       hugin = {
        #         description = "hugin";
        #         icon = "tailscale.png";
        #         href = "https://dash.jnsgr.uk";
        #         widget = {
        #           type = "tailscale";
        #           deviceid = "{{HOMEPAGE_VAR_TAILSCALE_HUGIN_DEVICE_ID}}";
        #           key = "{{HOMEPAGE_VAR_TAILSCALE_AUTH_KEY}}";
        #         };
        #       };
        #     }
        #   ];
        # }
      ];
      settings = {
        title = "homepage dashboard";
        # favicon = "";
        headerStyle = "clean"; # underlined, boxed, clean, boxedWidgets
        layout = {
          Media = {
            style = "row";
            columns = 3;
          };
          Services = {
            style = "row";
            columns = 3;
          };
          System = {
            style = "row";
            columns = 3;
          };
          # infra = {
          #   style = "row";
          #   columns = 4;
          # };
          # machines = {
          #   style = "row";
          #   columns = 4;
          # };
        };
        # background = {
        #   image = "";
        #   blur = ""; # sm, "", md, xl... see https://tailwindcss.com/docs/backdrop-blur
        #   saturate = 100; # 0, 50, 100... see https://tailwindcss.com/docs/backdrop-saturate
        #   brightness = 50; # 0, 50, 75... see https://tailwindcss.com/docs/backdrop-brightness
        #   opacity = 100; # 0-100
        # };
      };
      widgets = [
        {
          search = {
            provider = "google"; # google, duckduckgo, bing, baidu, brave or custom
            # focus = true; # Optional, will set focus to the search bar on page load
            # showSearchSuggestions = true; # Optional, will show search suggestions. Defaults to false
            target = "_blank"; # One of _self, _blank, _parent or _top
          };
        }
        # {
        #   resources = {
        #     label = "system";
        #     cpu = true;
        #     memory = true;
        #   };
        # }
        # {
        #   resources = {
        #     label = "storage";
        #     disk = [ "" ];
        #   };
        # }
        # {
        #   openmeteo = {
        #     label = "";
        #     timezone = "";
        #     latitude = "{{HOMEPAGE_VAR_LATITUDE}}";
        #     longitude = "{{HOMEPAGE_VAR_LONGITUDE}}";
        #     units = "metric"; # or imperial
        #     # cache = 5; # Time in minutes to cache API responses, to stay within limits
        #     # format = {
        #     #   # optional, Intl.NumberFormat options
        #     #   maximumFractionDigits = 1;
        #     # };
        #   };
        # }
      ];
      # kubernetes = { };
      # docker = { };
      # customJS = "";
      # customCSS = "";
    };

    sops = {
      templates.homepage-env = {
        content = ''
          HOMEPAGE_VAR_JELLYFIN_URL="${config.sops.placeholder."jellyfin/url"}"
          HOMEPAGE_VAR_JELLYFIN_API_KEY="${config.sops.placeholder."jellyfin/api_key"}"
          HOMEPAGE_VAR_RADARR_URL="${config.sops.placeholder."radarr/url"}"
          HOMEPAGE_VAR_RADARR_API_KEY="${config.sops.placeholder."radarr/api_key"}"
          HOMEPAGE_VAR_SONARR_URL="${config.sops.placeholder."sonarr/url"}"
          HOMEPAGE_VAR_SONARR_API_KEY="${config.sops.placeholder."sonarr/api_key"}"
          HOMEPAGE_VAR_PROWLARR_URL="${config.sops.placeholder."prowlarr/url"}"
          HOMEPAGE_VAR_PROWLARR_API_KEY="${config.sops.placeholder."prowlarr/api_key"}"
          HOMEPAGE_VAR_BAZARR_URL="${config.sops.placeholder."bazarr/url"}"
          HOMEPAGE_VAR_BAZARR_API_KEY="${config.sops.placeholder."bazarr/api_key"}"
          HOMEPAGE_VAR_LIDARR_URL="${config.sops.placeholder."lidarr/url"}"
          HOMEPAGE_VAR_LIDARR_API_KEY="${config.sops.placeholder."lidarr/api_key"}"
          HOMEPAGE_VAR_NEXTCLOUD_URL="${config.sops.placeholder."nextcloud/url"}"
          HOMEPAGE_VAR_NEXTCLOUD_TOKEN="${config.sops.placeholder."nextcloud/token"}"
          HOMEPAGE_VAR_NAVIDROME_URL="${config.sops.placeholder."navidrome/url"}"
          HOMEPAGE_VAR_NAVIDROME_USER="${config.sops.placeholder."navidrome/user"}"
          HOMEPAGE_VAR_NAVIDROME_TOKEN="${config.sops.placeholder."navidrome/token"}"
          HOMEPAGE_VAR_NAVIDROME_SALT="${config.sops.placeholder."navidrome/salt"}"
          HOMEPAGE_VAR_SEERR_URL="${config.sops.placeholder."seerr/url"}"
          HOMEPAGE_VAR_SEERR_API_KEY="${config.sops.placeholder."seerr/api_key"}"
          HOMEPAGE_VAR_SLSKD_URL="${config.sops.placeholder."slskd/url"}"
          HOMEPAGE_VAR_SLSKD_API_KEY="${config.sops.placeholder."slskd/api_key"}"
          HOMEPAGE_VAR_OPNSENSE_URL="${config.sops.placeholder."opnsense/url"}"
          HOMEPAGE_VAR_OPNSENSE_USERNAME="${config.sops.placeholder."opnsense/username"}"
          HOMEPAGE_VAR_OPNSENSE_PASSWORD="${config.sops.placeholder."opnsense/password"}"
          HOMEPAGE_VAR_DELUGE_URL="${config.sops.placeholder."deluge/url"}"
          HOMEPAGE_VAR_DELUGE_PASSWORD="${config.sops.placeholder."deluge/password"}"
          HOMEPAGE_VAR_GLANCES_URL="${config.sops.placeholder."glances/url"}"
          HOMEPAGE_VAR_KAVITA_URL="${config.sops.placeholder."kavita/url"}"
          HOMEPAGE_VAR_KAVITA_USERNAME="${config.sops.placeholder."kavita/username"}"
          HOMEPAGE_VAR_KAVITA_PASSWORD="${config.sops.placeholder."kavita/password"}"
          HOMEPAGE_VAR_VIKUNJA_URL="${config.sops.placeholder."vikunja/url"}"
          HOMEPAGE_VAR_VIKUNJA_KEY="${config.sops.placeholder."vikunja/key"}"
          HOMEPAGE_VAR_LATITUDE="${config.sops.placeholder."home/latitude"}"
          HOMEPAGE_VAR_LONGITUDE="${config.sops.placeholder."home/longitude"}"
        '';
      };
    };

    services.caddy.virtualHosts = {
      "homepage.${domainName}" = mkIf config.local.caddy.enable {
        extraConfig = ''
          reverse_proxy localhost:${toString cfg.port}
        '';
        useACMEHost = "${domainName}";
      };
    };

    sops = {
      secrets = {
        "home/latitude" = { };
        "home/longitude" = { };
      };
    };
  };
}
