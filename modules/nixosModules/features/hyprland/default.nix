{
  config,
  lib,
  pkgs,
  ...
}: let
  enabled = config.nixconf.desktop.session == "hyprland";
  templates = pkgs.runCommand "hyprland-desktop-templates" {} ''
    mkdir -p "$out"
    for template in ${../niri/templates}/*; do
      [ "$(basename "$template")" = niri.kdl ] || ln -s "$template" "$out/"
    done
    ln -s ${./theme.lua} "$out/hyprland.lua"
  '';
  desktop = pkgs.writeShellApplication {
    name = "hyprland-desktop";
    runtimeInputs = with pkgs; [(python3.withPackages (ps: [ps.pillow])) matugen awww fuzzel hyprland uwsm libnotify systemd waybar mako glib];
    text = ''
      export DESKTOP_COMPOSITOR=hyprland
      export NIRI_DESKTOP_DATA=/etc/hyprland-desktop
      export XDG_DATA_DIRS="${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:''${XDG_DATA_DIRS:-/run/current-system/sw/share}"
      exec python3 ${../niri/desktop.py} "$@"
    '';
  };
  launcher = pkgs.writeShellApplication {
    name = "hyprland-launcher";
    runtimeInputs = [pkgs.fuzzel pkgs.uwsm desktop];
    text = ''
      theme="$HOME/.local/state/niri-desktop/theme/fuzzel.ini"
      if [ ! -f "$theme" ]; then hyprland-desktop init; fi
      config="$theme"
      if [ -f "$HOME/.config/niri-desktop/fuzzel.ini" ]; then
        config="$HOME/.config/niri-desktop/fuzzel.ini"
      fi
      exec fuzzel --config "$config" --launch-prefix="uwsm app --" "$@"
    '';
  };
  lock = pkgs.writeShellApplication {
    name = "hyprland-lock";
    runtimeInputs = [pkgs.swaylock desktop];
    text = ''
      theme="$HOME/.local/state/niri-desktop/theme/swaylock.conf"
      if [ ! -f "$theme" ]; then
        if ! hyprland-desktop init; then exec swaylock --daemonize --color 1a1b26; fi
      fi
      wallpaper="$HOME/.local/state/niri-desktop/lock-wallpaper.png"
      if [ -f "$wallpaper" ]; then
        exec swaylock --daemonize --config "$theme" --image "$wallpaper" --scaling fill
      fi
      exec swaylock --daemonize --config "$theme"
    '';
  };
  clipboard = pkgs.writeShellApplication {
    name = "hyprland-clipboard";
    runtimeInputs = [pkgs.cliphist pkgs.wl-clipboard launcher];
    text = ''
      selection=$(cliphist list | hyprland-launcher --dmenu --prompt "Clipboard: ") || exit 0
      [ -n "$selection" ] || exit 0
      printf '%s' "$selection" | cliphist decode | wl-copy
    '';
  };
  displayPower = pkgs.writeShellApplication {
    name = "hyprland-display-power";
    runtimeInputs = [pkgs.hyprland];
    text = ''
      case "''${1:-}" in
        on|off) hyprctl dispatch "hl.dsp.dpms({action=\"$1\"})" ;;
        *) exit 2 ;;
      esac
    '';
  };
  screenshot = pkgs.writeShellApplication {
    name = "hyprland-screenshot";
    runtimeInputs = [pkgs.grim pkgs.slurp pkgs.wl-clipboard pkgs.libnotify];
    text = ''
      directory="$HOME/Pictures/Screenshots"
      mkdir -p "$directory"
      file="$directory/Screenshot-$(date +%Y%m%d-%H%M%S).png"
      if [ "''${1:-region}" = region ]; then
        geometry=$(slurp) || exit 0
        grim -g "$geometry" "$file"
      else
        grim "$file"
      fi
      wl-copy --type image/png < "$file"
      notify-send "Screenshot saved" "$file"
    '';
  };
  service = description: command: {
    inherit description;
    wantedBy = ["wayland-session@hyprland.desktop.target"];
    bindsTo = ["wayland-session@hyprland.desktop.target"];
    # UWSM publishes the compositor environment before the graphical session.
    # Keep the Hyprland lifetime binding, but wait for that environment barrier.
    after = ["wayland-session-waitenv.service"];
    enableDefaultPath = false;
    serviceConfig = {
      ExecStart = command;
      Restart = "on-failure";
      RestartSec = 2;
    };
  };
  themedService = description: command:
    lib.recursiveUpdate (service description command) {
      requires = ["hyprland-theme.service"];
      after = ["hyprland-theme.service"];
    };
in {
  config = lib.mkIf enabled {
    system.nixos.tags = ["Hyprland"];
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    security.rtkit.enable = true;
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.swaylock = {};
    xdg.portal.config.Hyprland = {
      default = ["hyprland" "gtk"];
      "org.freedesktop.impl.portal.FileChooser" = "gtk";
    };
    environment.systemPackages = with pkgs; [
      desktop
      launcher
      lock
      clipboard
      screenshot
      displayPower
      grim
      slurp
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
      "hyprland-desktop/templates".source = templates;
      "hyprland-desktop/settings.toml".source = ../niri/settings.toml;
      "hyprland-desktop/waybar.json".source = ./waybar.json;
      "hyprland-desktop/waybar.css".source = ../niri/waybar.css;
      "hyprland-desktop/README.md".source = ./README.md;
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
      hyprland-wallpaper = service "Hyprland wallpaper daemon" "${pkgs.awww}/bin/awww-daemon";
      hyprland-theme = lib.recursiveUpdate (service "Restore Hyprland wallpaper and palette" "${desktop}/bin/hyprland-desktop init") {
        requires = ["hyprland-wallpaper.service"];
        after = ["hyprland-wallpaper.service"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          Restart = "no";
        };
      };
      hyprland-waybar = themedService "Hyprland status bar" "${desktop}/bin/hyprland-desktop bar";
      # D-Bus activation must start the same themed daemon as the session.
      mako =
        (themedService "Hyprland notifications" "${pkgs.mako}/bin/mako --config %h/.local/state/niri-desktop/theme/mako.conf")
        // {
          aliases = ["hyprland-notifications.service"];
        };
      hyprland-polkit = service "Hyprland authentication agent" "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      hyprland-network = service "Hyprland network tray" "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
      hyprland-clipboard = service "Hyprland clipboard history" "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store";
      hyprland-idle = themedService "Hyprland idle lock and display power" (lib.concatStringsSep " " [
        "${pkgs.swayidle}/bin/swayidle -w"
        "timeout 600 '${lock}/bin/hyprland-lock'"
        "timeout 900 '${displayPower}/bin/hyprland-display-power off'"
        "resume '${displayPower}/bin/hyprland-display-power on'"
        "before-sleep '${lock}/bin/hyprland-lock'"
        "lock '${lock}/bin/hyprland-lock'"
      ]);
    };
  };
}
