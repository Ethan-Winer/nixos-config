{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];
	nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Bootloader
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  
  boot.loader.grub = {
    enable = true;
    useOSProber = true;
    efiSupport = true;
    devices = [ "nodev" ];
  };

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services = {
    displayManager.gdm.enable = true;
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
  };
  
  musnix = {
    enable = true;
    kernel.realtime = true;
    rtirq.enable = true;
  };

  # Networking
  networking.hostName = "laptop";
  networking.networkmanager.enable = true;

  # Other Hardware Stuff
  hardware.bluetooth.enable = true;
  services.tuned.enable = true;
  services.upower.enable = true;

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
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [];
  };



  # Packages
  nixpkgs.config.allowUnfree = true;
  
  programs.niri.enable = true;
  programs.git.enable = true;

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;
  
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
  };

  #Fonts
  fonts =  {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.fira-code
    ];

    fontconfig.defaultFonts = {
      serif = [ "FiraCode Nerd Font" ];
      sansSerif = [ "FiraCode Nerd Font" ];
      monospace = [ "FiraCode Nerd Font Mono" ];
    };
  };


  environment.systemPackages = with pkgs; [
    brightnessctl
    btop
  ];

  environment.sessionVariables = {
    
  };

  environment.variables = {

  };

  system.stateVersion = "25.11";
}
