# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname
  networking.networkmanager.enable = true;

  # Set your time zone
  time.timeZone = "America/Chicago";

  # Internationalisation properties
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

  # Enable X11 and Wayland requirements
  services.xserver.enable = true;
  programs.hyprland.enable = true;  # Enable Hyprland Wayland compositor
  programs.hyprland.xwayland.enable = true;  # Enable XWayland support
  
  # Enable SDDM display manager (commonly used with Hyprland)
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.defaultSession = "hyprland";
  
  # Configure keymap
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS for printing
  services.printing.enable = true;

  # Audio configuration with PipeWire
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User account
  users.users.brandonb = {
    isNormalUser = true;
    description = "Brandon Bergerson";
    extraGroups = [ "networkmanager" "wheel" "vboxsf" "video" "input" ];
    packages = with pkgs; [
      # Hyprland-specific utilities
      waybar              # Status bar
      dunst               # Notification daemon
      rofi-wayland        # Application launcher
      hyprpaper           # Wallpaper utility
      wlogout             # Logout menu
      grim                # Screenshot tool
      slurp               # Region selection for screenshots
      wl-clipboard        # Wayland clipboard utilities
      xdg-desktop-portal-hyprland  # XDG desktop integration
      
      # Common terminal and tools
      kitty             # Terminal emulator
      firefox           # Web browser
      libnotify         # For notifications
    ];
  };

  # Enable automatic login
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "brandonb";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # VirtualBox guest
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.x11 = true;

  # System packages
  environment.systemPackages = with pkgs; [
    # Core utilities
    vim
    wget
    
    # Additional Hyprland utilities
    brightnessctl     # Brightness control
    pamixer           # Audio mixer
    playerctl         # Media player control
    networkmanagerapplet  # Network manager tray
    
    # File manager (optional)
    dolphin
  ];

  # Fonts (commonly used with Hyprland)
  fonts.packages = with pkgs; [
    font-awesome
    noto-fonts
    noto-fonts-emoji
    fira-code
    jetbrains-mono
  ];

  # Enable necessary services for Hyprland
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];

  # Nix settings
  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    package = pkgs.nixFlakes;
  };
  
  nixpkgs.config.permittedInsecurePackages = [
    "teams-1.5.00.23861"
    "openssl-1.1.1w"
    "openssl-1.1.1v"
  ];

  system.stateVersion = "23.05";
}
