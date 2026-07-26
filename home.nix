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
    # programs.noctalia.enable = true;

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
            ms-python.python
            redhat.java
            vscjava.vscode-java-debug

            angular.ng-template
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
            "editor.fontSize" = "14";
            "editor.fontFamily" = "Fira Code Nerd Font Mono";
            "chat.disableAIFeatures" = true;
            "window.zoomLevel" = 0.5;
            "update.mode" = "none";
            "telemetry.feedback.enabled" = false;
        };
    };


    home.packages = with pkgs; [
        playerctl
        yt-dlp
        btop
        readest
        libreoffice-qt-fresh
        davinci-resolve
        google-chrome
        unzip
        gnome-clocks
        gnome-disk-utility
        
        quickemu
        nautilus
        imv
        ffmpeg
        celluloid
        gnome-text-editor

        cava
        asciiquarium

        noctalia-shell

        #coding
        jetbrains.rider
        gh
        # nodejs_26
        # dotnet-sdk_10
        penpot-desktop

        #3D Printing
        freecad
        orca-slicer

        # Music
        wineWow64Packages.yabridge
        yabridge
        yabridgectl
        reaper


        # pkgs.libsForQt5.qtstyleplugin-kvantum
        # pkgs.kdePackages.qtstyleplugin-kvantum
        # kdePackages.qt6ct
        # kdePackages.kde-cli-tools
        # catppuccin-qt5ct
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
    };
    
    gtk = {
        enable = true;
        
        theme = {
            name = "catppuccin-mocha-lavender-compact+rimless"; 
            package = pkgs.catppuccin-gtk.override {
                accents = [ "lavender" ];
                size = "compact";
                tweaks = [ "rimless" ];
                variant = "mocha";
            };
        };
    };

    

    dconf.settings = {
        "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            gtk-theme = "catppuccin-mocha-lavender-compact+rimless";
            icon-theme = "Papirus-Dark";
        };
    };

    # Cursor
    home.pointerCursor = {
        gtk.enable = true;
        package = pkgs.catppuccin-cursors.mochaDark;
        name = "catppuccin-mocha-dark-cursors";
        size = 24;
    };

    # Symlinks
    xdg.configFile."niri/config.kdl".source = ./configs/niri/config.kdl;
    xdg.configFile."alacritty/alacritty.toml".source = ./configs/alacritty/alacritty.toml;
    xdg.configFile."noctalia/settings.json".source = ./configs/noctalia/settings.json;

    home.stateVersion = "26.05";
}