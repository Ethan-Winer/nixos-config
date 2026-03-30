{config, pkgs, lib, inputs, ...}:
let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    flavor = "mocha";
    accent = "lavender";
in {
    imports = [
        inputs.spicetify-nix.homeManagerModules.default
        inputs.catppuccin.homeModules.catppuccin
    ];

    home.username = "ethan";
    home.homeDirectory = "/home/ethan";

    programs.fish.enable = true;
	programs.alacritty.enable = true;
	programs.vesktop.enable = true;
    programs.firefox = {
        enable = true;
        profiles.default = {
            extensions.force = true;
            settings = {
                "browser.newtabpage.activity-stream.showSponsored" = false;
                "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
                "browser.newtabpage.activity-stream.default.sites" = "";
                "browser.newtabpage.activity-stream.feeds.topsites" = false;
                "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
                "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
                "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
                "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
                "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
                "browser.newtabpage.activity-stream.showSearch" = true;
            };
        };
        policies = {
            ExtensionSettings = {
                "uBlock0@raymondhill.net" = {
                        default_area = "menupanel";
                        install_url = https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi;
                        installation_mode = "force_installed";
                };
                # catppuccin broswer theme
                # "{8446b178-c865-4f5c-8ccc-1d7887811ae3}" = {
                #     install_url = https://addons.mozilla.org/firefox/downloads/file/3990315/catppuccin_mocha_lavender_git-2.0.xpi;
                #     instalation_mode = "force_installed";
                # };
            };
        };
    };
	
    programs.vscode = {
        enable = true;
        mutableExtensionsDir = false;
        # Extensions
        profiles.default.extensions = with pkgs.vscode-extensions; [
            bbenoist.nix
            tamasfe.even-better-toml
        # Extensions From Marketplace
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
                name = "kdl";
                publisher = "kdl-org";
                version = "2.1.3";
                sha256 = "sha256-Jssmb5owrgNWlmLFSKCgqMJKp3sPpOrlEUBwzZSSpbM=";
            }
        ];
        # Settings
        profiles.default.userSettings = {
            "editor.fontSize" = "16";
            "chat.disableAIFeatures" = true;
        };
    };
    
    programs.waybar.enable = true;
    programs.fuzzel.enable = true;
    programs.wlogout.enable = true;
    programs.hyprlock.enable = true;

    home.packages = with pkgs; [
	    xwayland-satellite
        swaybg
        playerctl
        pavucontrol
        yt-dlp
        gh
        readest

        cava
        asciiquarium

        # Music
        # winetricks
        wineWowPackages.yabridge
        yabridge
        yabridgectl
        reaper
    ];

    programs.spicetify = {
        enable = true;
        wayland = true;
        enabledExtensions = with spicePkgs.extensions; [
            adblockify
            hidePodcasts
            shuffle
        ];
        theme = spicePkgs.themes.catppuccin;
        colorScheme = "${flavor}";
    };


    catppuccin = {
        enable = true;
        flavor = "${flavor}";
        accent = "${accent}";
        alacritty.enable = false;
        waybar.enable = false;

        cursors = {
            enable = true;
            accent = "dark";
        };

    };
    
    gtk = {
        enable = true;
        theme = {
            name = "catppuccin-${flavor}-${accent}-standard";
            package = pkgs.catppuccin-gtk.override {
                accents = [ "${accent}" ];
                variant = "${flavor}";
            };
        };
        iconTheme = {
            name = "Papirus-Dark";
            package = lib.mkForce (pkgs.catppuccin-papirus-folders.override {
                flavor = "${flavor}";
                accent = "${accent}";
            });
        };
    };

    # Symlinks

    # Firefox Theme
    # home.file.".mozilla/firefox/default/extcatppuccin_mocha_lavender_git-2.0.xpi".source = ./configs/firefox/catppuccin_mocha_lavender_git-2.0.xpi;

    # xdg.configFile."niri/config.kdl".source = ./configs/niri/config.kdl;
    home.file.".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "/home/ethan/nixos/configs/niri/config.kdl";
    # xdg.configFile."niri/wallpaper.jpg".source = ./wallpaper.jpg;

    xdg.configFile."alacritty/alacritty.toml".source = ./configs/alacritty/alacritty.toml;
    
    # xdg.configFile."waybar/config.jsonc".source = ./configs/waybar/config.jsonc;
    # xdg.configFile."waybar/style.css".source = ./configs/waybar/style.css;
    # xdg.configFile.".config/waybar/mocha.css".source =  ./configs/waybar/mocha.css;
    home.file.".config/waybar/config.jsonc".source = config.lib.file.mkOutOfStoreSymlink "/home/ethan/nixos/configs/waybar/config.jsonc";
    home.file.".config/waybar/style.css".source = config.lib.file.mkOutOfStoreSymlink "/home/ethan/nixos/configs/waybar/style.css";

    # xdg.configFile."waybar/macchiato.css".source = ./configs/waybar/macchiato.css;
    home.stateVersion = "25.11";
}