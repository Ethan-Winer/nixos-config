{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];
	nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Bootloader
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

  # Graphics
  hardware.graphics.enable = true;
	hardware.nvidia.open = false;

  #  Services
  
  # xdg.portal = {
  #   enable = true;
  #   extraPortals = with pkgs; [
  # #     # xdg-desktop-portal-gnome
  #     xdg-desktop-portal-gtk
  #   ];
  # #   config.common.deafault = [ "gnome" ];
  # };

  services = {
    desktopManager.gnome.enable = true; # convenience
    displayManager.gdm.enable = true;
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    
  };

  # Networking
  networking.hostName = "desktop";
  networking.networkmanager.enable = true;

  # Locale
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # User
  users.users.ethan = {
    isNormalUser = true;
    description = "ethan";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };



  # Packages
  nixpkgs.config.allowUnfree = true;
  
  programs.niri.enable = true;
  
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
  };

  programs.git.enable = true;

  fonts =  {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.fira-code
      # nerd-fonts.droid-sans-mono
    ];

    fontconfig.defaultFonts = {
      serif = [ "FiraCode Nerd Font Mono" ];
      sansSerif = [ "FiraCode Nerd Font Mono" ];
      monospace = [ "FiraCode Nerd Font Mono" ];
      # serif = [ "Droid Sans Mono" ];
      # sansSerif = [ "Droid Sans Mono" ];
      # monospace = [ "Droid Sans Mono" ];
    };
  };
  # stylix = {
  #   enable = true;
  #   base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  #   fonts = {
  #     serif = {
  #       package = pkgs.nerd-fonts.fira-code;
  #       name = "FiraCode Nerd Font Mono";
  #     };

  #     sansSerif = {
  #       package = pkgs.nerd-fonts.fira-code;
  #       name = "FiraCode Nerd Font Mono";
  #     };

  #     monospace = {
  #       package = pkgs.nerd-fonts.fira-code;
  #       name = "FiraCode Nerd Font Mono";
  #     };

  #   };
  # };


  environment.systemPackages = with pkgs; [

  ];

  environment.sessionVariables = {
    
    # NIXOS_OZONE_WL = "1";
  };
  system.stateVersion = "25.11";
}
