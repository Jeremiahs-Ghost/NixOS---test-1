{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "lyre";
  networking.networkmanager.enable = true;

  time.timeZone = "Australia/Melbourne";

  users.users.orpheus = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "vboxusers" ];
    shell = pkgs.bash;
  };

  # Sway / Wayland
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # Pipewire audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  # VirtualBox
  virtualisation.virtualbox.guest.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  security.polkit.enable = true;

  programs.thunar.enable = true;

  environment.systemPackages = with pkgs; [
    # Core / WM utilities
    kitty
    git
    vscode
    mpvpaper
    waybar
    rofi
    mako
    pavucontrol
    grim
    slurp
    swaylock
    swayidle
    polkit_gnome

    # Apps
    brave
    bitwarden
    obsidian
    discord
    deadbeef
    spotify
    kdePackages.okular
    libreoffice
    stremio
    vcv-rack
    bitwig-studio
    easyeffects
    mathematica
  ];

  system.stateVersion = "24.11";
}
