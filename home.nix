{config, pkgs, lib, inputs, ...}:
let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    flavor = "mocha";
    accent = "lavender";
in {
    imports = [
        inputs.spicetify-nix.homeManagerModules.default
        inputs.catppuccin.homeModules.catppuccin
        inputs.noctalia.homeModules.default
    ];

    home.username = "ethan";
    home.homeDirectory = "/home/ethan";

    programs.fish.enable = true;
	programs.alacritty.enable = true;
	programs.vesktop.enable = true;
    programs.noctalia-shell.enable = true;

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
            # "workbench.colorTheme" = "Catppuccin Mocha";
            "window.zoomLevel" = 0.5;
            "editor.allowVariableFonts" = false;
            "update.mode" = "none";
            "telemetry.feedback.enabled" = false;
        };
    };

    home.packages = with pkgs; [
	    xwayland-satellite
        playerctl
        yt-dlp
        gh
        readest
        libreoffice-qt-fresh
        davinci-resolve
        
        quickemu
        nautilus
        imv
        ffmpeg
        celluloid
        gnome-text-editor

        cava
        asciiquarium

        # Music
        wineWowPackages.yabridge
        yabridge
        yabridgectl
        reaper

        zulu25 

        pkgs.libsForQt5.qtstyleplugin-kvantum
        pkgs.kdePackages.qtstyleplugin-kvantum
        kdePackages.qt6ct
        kdePackages.kde-cli-tools
        catppuccin-qt5ct
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
    

  # GTK theme
  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-macchiato-lavender-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "lavender" ];
        variant = "macchiato";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = lib.mkForce (pkgs.catppuccin-papirus-folders.override {
        flavor = "macchiato";
        accent = "lavender";
      });
    };
    cursorTheme = {
      name = "catppuccin-macchiato-dark-cursors";
    };
  };

    # Qt theme
    qt = {
        enable = true;
        platformTheme.name = "qtct";
        style.name = "kvantum";
    };

    xdg.configFile."kdeglobals".text = ''
        [Icons]
        Theme=Papirus-Dark
    '';

    # Cursor
    home.pointerCursor = {
        gtk.enable = true;
        package = pkgs.catppuccin-cursors.mochaDark;
        name = "catppuccin-mocha-dark-cursors";
        size = 24;
    };


    # Symlinks
    # home.file.".config/niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "/home/ethan/NixOS/configs/niri/config.kdl";
    xdg.configFile."niri/config.kdl".source = ./configs/niri/config.kdl;
    xdg.configFile."alacritty/alacritty.toml".source = ./configs/alacritty/alacritty.toml;
    xdg.configFile."noctalia/settings.json".source = ./configs/noctalia/settings.json;

    home.stateVersion = "25.11";
}