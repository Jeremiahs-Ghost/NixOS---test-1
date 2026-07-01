{ config, pkgs, ... }:

{
  home.stateVersion = "24.11";

  # Terminal
  programs.kitty = {
    enable = true;
    themeFile = "Tokyo_Night";
  };

  programs.bash.enable = true;

  programs.starship = {
    enable = true;
    settings = {
      format = "[$username@$hostname $directory]($style)$character";
    };
  };

  # Wallpaper file - copied into the Nix store and symlinked into ~/Pictures
  home.file."Pictures/wallpaper.mp4".source = ./4935-181466751.mp4;

  # Sway
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4"; # Super/Windows key
      terminal = "kitty";

      bars = [
        { command = "waybar"; }
      ];

      menu = "rofi -show drun";

      startup = [
        { command = "mpvpaper -o 'loop no-audio' '*' ~/Pictures/wallpaper.mp4"; }
        { command = "mako"; }
        { command = "/run/wrappers/bin/polkit-gnome-authentication-agent-1"; }
      ];

      keybindings = let
        mod = "Mod4";
      in {
        "${mod}+Return" = "exec kitty";
        "${mod}+q" = "kill";
        "${mod}+f" = "fullscreen toggle";
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+d" = "exec rofi -show drun";
        "${mod}+e" = "exec thunar";
        "${mod}+Escape" = "exec swaylock";

        # Focus movement (vim-style)
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        # Move windows
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

        # Workspaces
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";

        # Screenshots
        "Print" = "exec grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png";
        "${mod}+Print" = "exec grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png";

        # Volume (requires wpctl, ships with pipewire)
        "XF86AudioRaiseVolume" = "exec wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

        # Reload / exit
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+e" = "exec swaynag -t warning -m 'Exit Sway?' -B 'Yes' 'swaymsg exit'";
      };
    };
  };
}
