{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  inherit (config.local.networking) domainName;
  cfg = config.local.glance;
in
{
  options.local.glance = {
    enable = mkEnableOption "glance";
    port = mkOption {
      type = types.port;
      default = 5678;
    };
  };

  config = mkIf cfg.enable {
    services.glance = {
      enable = true;
      openFirewall = true;

      # see https://github.com/glanceapp/glance/blob/main/docs/configuration.md
      settings = {
        server.port = cfg.port;
        server.host = "0.0.0.0";
        # https://github.com/glanceapp/glance/blob/main/docs/themes.md
        # Catppuccin Mocha
        theme = {
          background-color = "240 21 15";
          contrast-multiplier = 1.2;
          primary-color = "217 92 83";
          positive-color = "115 54 76";
          negative-color = "347 70 65";
        };
        pages = [
          {
            name = "Home";
            # Optionally, if you only have a single page you can hide the desktop navigation for a cleaner look
            # hide-desktop-navigation = true
            columns = [
              {
                size = "small";
                widgets = [
                  {
                    type = "calendar";
                    first-day-of-week = "monday";
                  }
                  {
                    type = "rss";
                    limit = 10;
                    collapse-after = 3;
                    cache = "12h";
                    feeds = [
                      {
                        url = "https://selfh.st/rss/";
                        title = "selfh.st";
                        limit = 4;
                      }
                      {
                        url = "https://ciechanow.ski/atom.xml";
                      }
                      {
                        url = "https://www.joshwcomeau.com/rss.xml";
                        title = "Josh Comeau";
                      }
                      {
                        url = "https://samwho.dev/rss.xml";
                      }
                      {
                        url = "https://ishadeed.com/feed.xml";
                        title = "Ahmad Shadeed";
                      }
                    ];
                  }
                  {
                    type = "twitch-channels";
                    channels = [
                      "theprimeagen"
                      "j_blow"
                      "giantwaffle"
                      "cohhcarnage"
                      "christitustech"
                      "EJ_SA"
                    ];
                  }
                  {
                    type = "server-stats";
                    servers = [
                      {
                        type = "local";
                        name = "tomori";
                      }
                    ];
                  }
                ];
              }
              {
                size = "full";
                widgets = [
                  {
                    type = "group";
                    widgets = [
                      { type = "hacker-news"; }
                      { type = "lobsters"; }
                    ];
                  }
                  {
                    type = "videos";
                    channels = [
                      "UCXuqSBlHAE6Xw-yeJA0Tunw" # Linus Tech Tips
                      "UCR-DXc1voovS8nhAvccRZhg" # Jeff Geerling
                      "UCsBjURrPoezykLs9EqgamOA" # Fireship
                      "UCBJycsmduvYEL83R_U4JriQ" # Marques Brownlee
                      "UCHnyfMqiRRG1u-2MsSQLbXA" # Veritasium
                    ];

                  }
                  {
                    type = "group";
                    widgets = [
                      {
                        type = "reddit";
                        subreddit = "technology";
                        show-thumbnails = true;
                      }
                      {
                        type = "reddit";
                        subreddit = "selfhosted";
                        show-thumbnails = true;
                      }
                    ];
                  }
                ];
              }
              {
                size = "small";
                widgets = [
                  {
                    type = "weather";
                    location = {
                      _secret = config.sops.secrets."home/location".path;
                    };
                    units = "metric"; # imperial
                    hour-format = "12h"; # 24h
                    # hide-location = true;
                  }
                  {
                    type = "markets";
                    markets = [
                      {
                        symbol = "SPY";
                        name = "S&P 500";
                      }
                      {
                        symbol = "BTC-USD";
                        name = "Bitcoin";
                        # chart-link = "https://www.tradingview.com/chart/?symbol=INDEX:BTCUSD";
                      }
                      {
                        symbol = "NVDA";
                        name = "NVIDIA";
                      }
                      {
                        symbol = "AAPL";
                        name = "Apple";
                        # symbol-link = "https://www.google.com/search?tbm=nws&q=apple";
                      }
                      {
                        symbol = "MSFT";
                        name = "Microsoft";
                      }
                    ];
                  }
                  {
                    type = "releases";
                    cache = "1d";
                    # Without authentication the Github API allows for up to 60 requests per hour. You can create a
                    # read-only token from your Github account settings and use it here to increase the limit.
                    # token = ...
                    repositories = [
                      "glanceapp/glance"
                      "go-gitea/gitea"
                      "immich-app/immich"
                      "syncthing/syncthing"
                    ];
                  }
                  {
                    type = "clock";
                    hour-format = "24h";
                    # https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
                    timezones = [
                      {
                        timezone = "America/New_York";
                        label = "New York";
                      }
                      {
                        timezone = "Asia/Tokyo";
                        label = "Tokyo";
                      }
                    ];
                  }
                ];
              }
            ];
          }
          {
            name = "Links";
            columns = [
              {
                size = "full";
                widgets = [
                  {
                    type = "search";
                    search-engine = "duckduckgo"; # duckduckgo,google,bing,perplexity,kagi,starpage
                    bangs = [
                      {
                        title = "YouTube";
                        shortcut = "!yt";
                        url = "https://www.youtube.com/results?search_query={QUERY}";
                      }
                      {
                        title = "Amazon";
                        shortcut = "!az";
                        url = "https://www.amazon.com/s?k={QUERY}";
                      }
                      {
                        title = "Reddit";
                        shortcut = "!rd";
                        url = "https://www.reddit.com/search?q={QUERY}";
                      }
                    ];
                  }
                  {
                    type = "monitor";
                    cahce = "1m";
                    title = "Services";
                    sites =
                      let
                        addSite =
                          {
                            name,
                            url,
                            icon ? "di:${url}",
                          }:
                          {
                            title = name;
                            url = "https://${url}.${domainName}";
                            icon = "${icon}.png";
                          };
                      in
                      map addSite [
                        # si for Simple icons https://simpleicons.org/
                        # sh for selfh.st icons https://selfh.st/icons/
                        # di for Dashboard icons https://github.com/homarr-labs/dashboard-icons
                        # mdi for Material Design icons https://pictogrammers.com/library/mdi/
                        {
                          name = "Bazarr";
                          url = "bazarr";
                        }
                        {
                          name = "Lidarr";
                          url = "lidarr";
                        }
                        {
                          name = "Prowlarr";
                          url = "prowlarr";
                        }
                        {
                          name = "Radarr";
                          url = "radarr";
                        }
                        {
                          name = "Sonarr";
                          url = "sonarr";
                        }
                        {
                          name = "Seerr";
                          url = "seerr";
                        }
                        {
                          name = "Actual Budget";
                          url = "acutal";
                          icon = "di:actual-budget";
                        }
                        {
                          name = "AriaNg";
                          url = "ariang";
                        }
                        {
                          name = "Deluge";
                          url = "deluge";
                        }
                        {
                          name = "Glances";
                          url = "glances";
                        }
                        {
                          name = "Home Assistant";
                          url = "home-assistant";
                        }
                        {
                          name = "Homepage";
                          url = "homepage";
                        }
                        {
                          name = "Jellyfin";
                          url = "jellyfin";
                        }
                        {
                          name = "Kavita";
                          url = "kavita";
                        }
                        {
                          name = "Memos";
                          url = "memos";
                        }
                        {
                          name = "Miniflux";
                          url = "miniflux";
                        }
                        {
                          name = "Navidrome";
                          url = "navidrome";
                        }
                        {
                          name = "Nextcloud";
                          url = "nextcloud";
                        }
                        {
                          name = "Slskd";
                          url = "slskd";
                        }
                        {
                          name = "Vaultwarden";
                          url = "vaultwarden";
                        }
                        {
                          name = "Vikunja";
                          url = "vikunja";
                        }
                        {
                          name = "Wealthfolio";
                          url = "wealthfolio";
                          icon = "sh:wealthfolio";
                        }
                        # {
                        #   name = "Uptime Kuma";
                        #   icon = "uptime-kuma";
                        # }
                      ];
                  }
                  {
                    type = "bookmarks";
                    groups = [
                      {
                        links = [
                          {
                            title = "Gmail";
                            url = "https://mail.google.com/mail/u/0/";
                          }
                          {
                            title = "Amazon";
                            url = "https://www.amazon.com/";
                          }
                          {
                            title = "Github";
                            url = "https://github.com/";
                          }
                          {
                            title = "Wikipedia";
                            url = "https://en.wikipedia.org/";
                          }
                        ];
                      }
                      {
                        title = "Entertainment";
                        color = "10 70 50";
                        links = [
                          {
                            title = "YouTube";
                            url = "https://www.youtube.com/";
                          }
                        ];
                      }
                      {
                        title = "Social";
                        color = "200 50 50";
                        links = [
                          {
                            title = "Reddit";
                            url = "https://www.reddit.com/";
                          }
                          {
                            title = "Twitter";
                            url = "https://twitter.com/";
                          }
                          {
                            title = "Instagram";
                            url = "https://www.instagram.com/";
                          }
                        ];
                      }
                    ];
                  }
                ];
              }
            ];
          }
        ];
      };
    };

    services.caddy.virtualHosts = {
      "glance.${domainName}" = mkIf config.local.caddy.enable {
        extraConfig = ''
          reverse_proxy localhost:${toString cfg.port}
        '';
        useACMEHost = "${domainName}";
      };
    };

    sops = {
      secrets = {
        "home/location" = { };
      };
    };
  };
}
