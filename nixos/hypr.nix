{ config, lib, pkgs, ... }:

{
  programs.hyprland.enable = true;

  security.pam.services.hyprlock = { };

  environment.systemPackages = with pkgs; [
    rofi
    rofimoji
    rofi-emoji
    hyprland
    hyprlock
    hypridle
    awww
    hyprshot
    waybar
    fuzzel
    swaynotificationcenter
    hyprpicker
    grim
    cliphist
    slurp
    wl-clipboard
    jq
    wireguard-tools
    networkmanagerapplet
    playerctl
    libnotify
    xdg-desktop-portal-hyprland
    kdePackages.plasma-systemmonitor
    kdePackages.kdialog
    bibata-cursors
    nerd-fonts.jetbrains-mono
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.jetbrains-mono
  ];
}
