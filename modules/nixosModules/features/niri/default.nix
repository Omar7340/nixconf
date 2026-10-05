{
  config,
  lib,
  pkgs,
  ...
}: let
  enabled = config.nixconf.desktop.session == "niri";
  desktop = pkgs.writeShellApplication {
    name = "niri-desktop";
    runtimeInputs = with pkgs; [(python3.withPackages (ps: [ps.pillow])) matugen awww fuzzel niri libnotify systemd waybar mako glib];
    text = ''
      export XDG_DATA_DIRS="${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:''${XDG_DATA_DIRS:-/run/current-system/sw/share}"
      exec python3 ${./desktop.py} "$@"
    '';
  };
  launcher = pkgs.writeShellApplication {
    name = "niri-launcher";
    runtimeInputs = [pkgs.fuzzel desktop];
    text = ''
      theme="$HOME/.local/state/niri-desktop/theme/fuzzel.ini"
      if [ ! -f "$theme" ]; then niri-desktop init; fi
      config="$theme"
      if [ -f "$HOME/.config/niri-desktop/fuzzel.ini" ]; then
        config="$HOME/.config/niri-desktop/fuzzel.ini"
      fi
      exec fuzzel --config "$config" "$@"
    '';
  };
  lock = pkgs.writeShellApplication {
    name = "niri-lock";
    runtimeInputs = [pkgs.swaylock desktop];
    text = ''
      theme="$HOME/.local/state/niri-desktop/theme/swaylock.conf"
      if [ ! -f "$theme" ]; then
        if ! niri-desktop init; then exec swaylock --daemonize --color 1a1b26; fi
      fi
      wallpaper="$HOME/.local/state/niri-desktop/lock-wallpaper.png"
      if [ -f "$wallpaper" ]; then
        exec swaylock --daemonize --config "$theme" --image "$wallpaper" --scaling fill
      fi
      exec swaylock --daemonize --config "$theme"
    '';
  };
  clipboard = pkgs.writeShellApplication {
    name = "niri-clipboard";
    runtimeInputs = [pkgs.cliphist pkgs.wl-clipboard launcher];
    text = ''
      selection=$(cliphist list | niri-launcher --dmenu --prompt "Clipboard: ") || exit 0
      [ -n "$selection" ] || exit 0
      printf '%s' "$selection" | cliphist decode | wl-copy
    '';
  };
  service = description: command: {
    inherit description;
    wantedBy = ["niri.service"];
    bindsTo = ["niri.service"];
    after = ["niri.service"];
    enableDefaultPath = false;
    serviceConfig = {
      ExecStart = command;
      Restart = "on-failure";
      RestartSec = 2;
    };
  };
  themedService = description: command:
    lib.recursiveUpdate (service description command) {
      requires = ["niri-theme.service"];
      after = ["niri-theme.service"];
    };
in {
  config = lib.mkIf enabled {
    system.nixos.tags = ["Niri"];
    programs.niri = {
      enable = true;
      useNautilus = false;
    };
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    security.rtkit.enable = true;
    security.pam.services.swaylock = {};
    xdg.portal.config.niri."org.freedesktop.impl.portal.ScreenCast" = "gnome";
    environment.systemPackages = with pkgs; [
      desktop
      launcher
      lock
      clipboard
      xwayland-satellite
      fuzzel
      waybar
      mako
      awww
      swayidle
      swaylock
      wl-clipboard
      cliphist
      playerctl
      pavucontrol
      networkmanagerapplet
      polkit_gnome
      kdePackages.dolphin
      adw-gtk3
      papirus-icon-theme
      bibata-cursors
      xdg-utils
    ];
    environment.etc = {
      "niri-desktop/templates".source = ./templates;
      "niri-desktop/settings.toml".source = ./settings.toml;
      "niri-desktop/waybar.json".source = ./waybar.json;
      "niri-desktop/waybar.css".source = ./waybar.css;
      "niri-desktop/README.md".source = ./README.md;
    };
    # GTK color overrides are runtime generated in the user's home, rather
    # than Stylix-owned symlinks. KDE keeps its existing Stylix configuration.
    stylix.targets.gtk.enable = false;
    stylix.targets.qt.enable = false;
    qt = {
      enable = true;
      platformTheme = "qt5ct";
    };
    systemd.user.services = {
      niri-wallpaper = service "Niri wallpaper daemon" "${pkgs.awww}/bin/awww-daemon";
      niri-theme = lib.recursiveUpdate (service "Restore Niri wallpaper and palette" "${desktop}/bin/niri-desktop init") {
        requires = ["niri-wallpaper.service"];
        after = ["niri-wallpaper.service"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          Restart = "no";
        };
      };
      niri-waybar = themedService "Niri status bar" "${desktop}/bin/niri-desktop bar";
      # D-Bus activation must start the same themed daemon as the session.
      mako =
        (themedService "Niri notifications" "${pkgs.mako}/bin/mako --config %h/.local/state/niri-desktop/theme/mako.conf")
        // {
          aliases = ["niri-notifications.service"];
        };
      niri-polkit = service "Niri authentication agent" "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      niri-network = service "Niri network tray" "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
      niri-clipboard = service "Niri clipboard history" "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store";
      niri-idle = themedService "Niri idle lock and display power" (lib.concatStringsSep " " [
        "${pkgs.swayidle}/bin/swayidle -w"
        "timeout 600 '${lock}/bin/niri-lock'"
        "timeout 900 '${pkgs.niri}/bin/niri msg action power-off-monitors'"
        "resume '${pkgs.niri}/bin/niri msg action power-on-monitors'"
        "before-sleep '${lock}/bin/niri-lock'"
        "lock '${lock}/bin/niri-lock'"
      ]);
    };
  };
}
