"""Wallpaper-driven desktop controls; all generated files live in user state."""
import fcntl
import configparser
import io
import json
import os
from pathlib import Path
import random
import shutil
import subprocess
import sys
import tempfile
import time
import tomllib
from PIL import Image, ImageEnhance, ImageOps

HOME = Path.home()
COMPOSITOR = os.environ.get("DESKTOP_COMPOSITOR", "niri")
PREFIX = "hyprland" if COMPOSITOR == "hyprland" else "niri"
DATA = Path(os.environ.get("NIRI_DESKTOP_DATA", "/etc/niri-desktop"))
CONFIG = HOME / ".config/niri-desktop"
STATE = HOME / ".local/state/niri-desktop"
THEME = STATE / "theme"
EXTENSIONS = {".png", ".jpg", ".jpeg", ".webp"}


def run(*args, check=True, **kwargs):
    return subprocess.run(args, check=check, **kwargs)


def settings():
    value = tomllib.loads((DATA / "settings.toml").read_text())
    local = CONFIG / "settings.toml"
    if local.exists():
        value.update(tomllib.loads(local.read_text()))
    if value["mode"] not in {"dark", "light"}:
        raise ValueError("mode must be dark or light")
    return value


def files(cfg):
    folder = Path(cfg["wallpaper_directory"]).expanduser()
    return sorted(p for p in folder.rglob("*")
                  if p.is_file() and p.suffix.lower() in EXTENSIONS
                  and "\n" not in str(p)) if folder.is_dir() else []


def choose(prompt, choices):
    config = CONFIG / "fuzzel.ini"
    if not config.exists():
        config = THEME / "fuzzel.ini"
    result = run("fuzzel", "--config", str(config), "--dmenu", "--index",
                 "--prompt", prompt + ": ", input="\n".join(choices),
                 text=True, capture_output=True, check=False)
    if result.returncode != 0 or not result.stdout.strip():
        return None
    return int(result.stdout.strip())


def atomic(path, contents):
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(path.name + ".new")
    temporary.write_text(contents)
    temporary.replace(path)


def gtk_import(version):
    # Preserve any pre-existing user CSS and refuse to overwrite managed links.
    path = HOME / f".config/gtk-{version}.0/gtk.css"
    if path.is_symlink():
        print(f"Leaving managed GTK stylesheet untouched: {path}", file=sys.stderr)
        return
    entry = f'@import url("{THEME / "gtk.css"}");'
    contents = path.read_text() if path.exists() else ""
    # KDE may leave an imported colors.css behind. Apply our colors last,
    # preserving user rules while overriding those stale color definitions.
    contents = contents.replace(entry, "").strip()
    atomic(path, (contents + "\n" if contents else "") + entry + "\n")


def update_ini(path, sections):
    if path.is_symlink():
        print(f"Leaving managed configuration untouched: {path}", file=sys.stderr)
        return
    ini = configparser.ConfigParser(interpolation=None, strict=False)
    ini.optionxform = str
    if path.exists():
        ini.read(path)
        backup = path.with_name(path.name + ".before-niri-theme")
        if not backup.exists():
            shutil.copyfile(path, backup)
    for section, values in sections.items():
        if not ini.has_section(section):
            ini.add_section(section)
        for key, value in values.items():
            ini.set(section, key, value)
    text = io.StringIO()
    ini.write(text, space_around_delimiters=False)
    atomic(path, text.getvalue())


def application_theme(cfg):
    colors = json.loads((THEME / "greeter.json").read_text())
    # QPalette roles 0..21; Qt 6.6+ adds Accent as role 21.
    roles = ["text", "container", "outline", "container", "surface", "outline",
             "text", "text", "text", "base", "surface", "surface", "primary",
             "onPrimary", "primary", "tertiary", "container", "surface",
             "container", "text", "muted", "primary"]
    palette = ", ".join(colors[role] for role in roles)
    disabled = ", ".join(colors["muted"] if role in {"text", "onPrimary"}
                         else colors[role] for role in roles)
    atomic(THEME / "qt.colors", "[ColorScheme]\nactive_colors=" + palette
           + "\ninactive_colors=" + palette + "\ndisabled_colors=" + disabled + "\n")
    font = '"JetBrainsMono Nerd Font,11,-1,5,50,0,0,0,0,0"'
    for version in (5, 6):
        update_ini(HOME / f".config/qt{version}ct/qt{version}ct.conf", {
            "Appearance": {"color_scheme_path": str(THEME / "qt.colors"),
                           "custom_palette": "true", "style": "Fusion",
                           "icon_theme": "Papirus-Dark" if cfg["mode"] == "dark" else "Papirus-Light"},
            "Fonts": {"general": font, "fixed": font},
        })
    def rgb(key):
        value = colors[key].lstrip("#")
        return ",".join(str(int(value[i:i+2], 16)) for i in (0, 2, 4))
    sections = {
        "General": {"ColorScheme": "NiriWallpaper", "Name": "Niri Wallpaper",
                    "font": font.strip('"'), "fixed": font.strip('"'),
                    "menuFont": font.strip('"'), "toolBarFont": font.strip('"'),
                    "smallestReadableFont": font.strip('"')},
        "Icons": {"Theme": "Papirus-Dark" if cfg["mode"] == "dark" else "Papirus-Light"},
    }
    for name, bg, fg in [("Window", "surface", "text"), ("View", "base", "text"),
                         ("Button", "container", "text"), ("Selection", "primary", "onPrimary"),
                         ("Tooltip", "container", "text"), ("Complementary", "container", "text")]:
        sections[f"Colors:{name}"] = {
            "BackgroundNormal": rgb(bg), "BackgroundAlternate": rgb("container"),
            "ForegroundNormal": rgb(fg), "ForegroundInactive": rgb("muted"),
            "ForegroundLink": rgb("primary"), "ForegroundVisited": rgb("tertiary"),
            "ForegroundNegative": rgb("error"), "DecorationFocus": rgb("primary"),
            "DecorationHover": rgb("secondary"),
        }
    update_ini(HOME / ".local/share/color-schemes/NiriWallpaper.colors", sections)
    update_ini(HOME / ".config/kdeglobals", sections)
    for version in (3, 4):
        update_ini(HOME / f".config/gtk-{version}.0/settings.ini", {
            "Settings": {"gtk-font-name": "JetBrainsMono Nerd Font 11",
                         "gtk-theme-name": "adw-gtk3-dark" if cfg["mode"] == "dark" else "adw-gtk3",
                         "gtk-icon-theme-name": "Papirus-Dark" if cfg["mode"] == "dark" else "Papirus-Light"},
        })


def publish_greeter(image, cfg):
    directory = Path(os.environ.get("NIRI_GREETER_STATE", "/var/lib/niri-greeter"))
    if image:
        # Decode as the desktop user, never as root or the SDDM account.
        with Image.open(image) as original:
            picture = ImageOps.exif_transpose(original).convert("RGB")
            picture.thumbnail((3440, 1440), Image.Resampling.LANCZOS)
            temporary = STATE / "lock-wallpaper.new.png"
            ImageEnhance.Brightness(picture).enhance(0.45).save(temporary)
            temporary.replace(STATE / "lock-wallpaper.png")
            if directory.is_dir() and os.access(directory, os.W_OK):
                temporary = directory / "wallpaper.new.png"
                picture.save(temporary)
                temporary.chmod(0o640)
                temporary.replace(directory / "wallpaper.png")
    else:
        (STATE / "lock-wallpaper.png").unlink(missing_ok=True)
        if directory.is_dir() and os.access(directory, os.W_OK):
            (directory / "wallpaper.png").unlink(missing_ok=True)
    if directory.is_dir() and os.access(directory, os.W_OK):
        atomic(directory / "theme.json", (THEME / "greeter.json").read_text())
        (directory / "theme.json").chmod(0o640)


def generate(image, cfg):
    THEME.mkdir(parents=True, exist_ok=True)
    # Render into a staging directory so template errors leave the last theme intact.
    with tempfile.TemporaryDirectory(dir=STATE) as tmp:
        temp = Path(tmp)
        text = '[config.wallpaper]\nset = false\ncommand = "true"\narguments = []\n'
        for template in sorted((DATA / "templates").iterdir()):
            source = CONFIG / "templates" / template.name
            if not source.is_file():
                source = template
            text += (f"\n[templates.{template.stem}]\n"
                     f"input_path = {json.dumps(str(source))}\n"
                     f"output_path = {json.dumps(str(temp / template.name))}\n")
        (temp / "config.toml").write_text(text)
        args = ["matugen", "--config", str(temp / "config.toml"),
                "--mode", cfg["mode"], "--type", cfg["scheme"],
                "--contrast", str(cfg["contrast"]), "--source-color-index", "0"]
        args += ["image", str(image)] if image else ["color", "hex", cfg["fallback_color"]]
        run(*args)
        if COMPOSITOR == "niri":
            run("niri", "validate", "--config", str(temp / "niri.kdl"))
        else:
            run("Hyprland", "--verify-config", "--config", str(temp / "hyprland.lua"))
        for template in (DATA / "templates").iterdir():
            (temp / template.name).replace(THEME / template.name)
    for version in (3, 4):
        gtk_import(version)
    style = CONFIG / "waybar.css"
    if not style.is_file():
        style = DATA / "waybar.css"
    atomic(STATE / "waybar.css", f'@import url("{THEME / "waybar.css"}");\n'
           + f'@import url("{style}");\n')
    application_theme(cfg)


def wallpaper(image, cfg):
    if not os.environ.get("WAYLAND_DISPLAY"):
        return
    for _ in range(50):
        if run("awww", "query", check=False, stdout=subprocess.DEVNULL,
               stderr=subprocess.DEVNULL).returncode == 0:
            break
        time.sleep(0.1)
    if image:
        run("awww", "img", str(image), "--transition-type", cfg["transition"],
            "--transition-duration", "1", "--resize", "crop")
    else:
        run("awww", "clear", cfg["fallback_color"].lstrip("#"))


def refresh():
    if not os.environ.get("WAYLAND_DISPLAY"):
        return
    # On first login Mako starts after this oneshot. Avoid D-Bus activation
    # of another notification server while the theme is still initializing.
    active = run("systemctl", "--user", "is-active", "--quiet",
                 "mako.service", check=False).returncode == 0
    if active:
        run("makoctl", "reload", check=False, stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL)
    cfg = settings()
    run("gsettings", "set", "org.gnome.desktop.interface", "gtk-theme",
        "adw-gtk3-dark" if cfg["mode"] == "dark" else "adw-gtk3", check=False)
    run("gsettings", "set", "org.gnome.desktop.interface", "color-scheme",
        "prefer-dark" if cfg["mode"] == "dark" else "default", check=False)
    run("gsettings", "set", "org.gnome.desktop.interface", "font-name",
        "JetBrainsMono Nerd Font 11", check=False)
    run("gsettings", "set", "org.gnome.desktop.interface", "monospace-font-name",
        "JetBrainsMono Nerd Font 11", check=False)
    # Waybar's in-process CSS reload crashed in the physical session. A short
    # supervised restart loads the new palette without retaining GTK CSS state.
    if run("systemctl", "--user", "is-active", "--quiet",
           f"{PREFIX}-waybar.service", check=False).returncode == 0:
        run("systemctl", "--user", "restart", f"{PREFIX}-waybar.service",
            check=False, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    if COMPOSITOR == "hyprland":
        run("hyprctl", "reload", check=False, stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL)


def apply(image, cfg):
    with (STATE / "theme.lock").open("w") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        generate(image, cfg)
        if image:
            cache = STATE / ("wallpaper" + image.suffix.lower())
            if image.resolve() != cache.resolve():
                shutil.copyfile(image, cache.with_name(cache.name + ".new"))
                cache.with_name(cache.name + ".new").replace(cache)
            atomic(STATE / "wallpaper.json", json.dumps({"source": str(image), "cache": str(cache)}))
        wallpaper(image, cfg)
        publish_greeter(image, cfg)
        refresh()


def init(cfg):
    image = None
    history = STATE / "wallpaper.json"
    if history.exists():
        saved = json.loads(history.read_text())
        image = next((Path(saved[k]) for k in ("source", "cache")
                      if Path(saved[k]).is_file()), None)
    if image is None:
        images = files(cfg)
        image = random.choice(images) if images else None
    try:
        apply(image, cfg)
    except (subprocess.CalledProcessError, OSError) as error:
        print(f"Wallpaper restore failed ({error}); using fallback palette", file=sys.stderr)
        apply(None, cfg)
    (HOME / "Pictures/Screenshots").mkdir(parents=True, exist_ok=True)


def customize():
    options = ["Keyboard shortcuts and window layout", "Wallpaper and palette settings",
               "Bar modules", "Bar appearance", "Theme templates", "Desktop guide"]
    index = choose("Customize", options)
    if index is None:
        return
    CONFIG.mkdir(parents=True, exist_ok=True)
    local = HOME / (".config/hypr/local.lua" if COMPOSITOR == "hyprland" else ".config/niri/local.kdl")
    local.parent.mkdir(parents=True, exist_ok=True)
    if not local.exists():
        local.write_text('-- Personal overrides; run hyprctl reload after editing.\n' if COMPOSITOR == "hyprland" else '// Personal overrides; Niri reloads this file automatically.\n')
    for filename in ("settings.toml", "waybar.json", "waybar.css"):
        if not (CONFIG / filename).exists():
            shutil.copyfile(DATA / filename, CONFIG / filename)
    if index == 4:
        shutil.copytree(DATA / "templates", CONFIG / "templates", dirs_exist_ok=False) if not (CONFIG / "templates").exists() else None
        target = CONFIG / "templates"
    else:
        target = [local, CONFIG / "settings.toml", CONFIG / "waybar.json",
                  CONFIG / "waybar.css", None, DATA / "README.md"][index]
    run("kitty", "yazi" if target.is_dir() else "nvim", str(target))


def power():
    options = ["Lock", "Suspend", "Log out", "Reboot", "Shut down"]
    index = choose("Power", options)
    if index is None:
        return
    if index == 0:
        run(f"{PREFIX}-lock")
    elif index == 1:
        run(f"{PREFIX}-lock")
        run("systemctl", "suspend")
    elif choose("Confirm", ["Cancel", options[index]]) == 1:
        if index == 2:
            if COMPOSITOR == "hyprland":
                run("uwsm", "stop")
            else:
                run("niri", "msg", "action", "quit", "--skip-confirmation")
        else:
            run("systemctl", "reboot" if index == 3 else "poweroff")


def main():
    STATE.mkdir(parents=True, exist_ok=True)
    cfg = settings()
    command = sys.argv[1] if len(sys.argv) > 1 else "pick"
    if command == "init":
        init(cfg)
    elif command == "bar":
        config = CONFIG / "waybar.json"
        if not config.is_file():
            config = DATA / "waybar.json"
        if COMPOSITOR == "hyprland":
            # Adapt existing custom bars without modifying the user's original.
            value = config.read_text().replace('niri/workspaces', 'hyprland/workspaces').replace('niri/window', 'hyprland/window').replace('niri-', 'hyprland-').replace('{index}', '{id}')
            config = STATE / "hyprland-waybar.json"
            atomic(config, value)
        os.execvp("waybar", ["waybar", "--config", str(config), "--style", str(STATE / "waybar.css")])
    elif command in {"pick", "random"}:
        if not (THEME / "fuzzel.ini").exists():
            init(cfg)
        images = files(cfg)
        if not images:
            raise ValueError(f'No wallpapers found in {cfg["wallpaper_directory"]}')
        index = random.randrange(len(images)) if command == "random" else choose(
            "Wallpaper", [str(p.relative_to(Path(cfg["wallpaper_directory"]).expanduser())) for p in images])
        if index is not None:
            apply(images[index], cfg)
    elif command == "apply" and len(sys.argv) == 3:
        apply(Path(sys.argv[2]).expanduser().resolve(strict=True), cfg)
    elif command == "settings":
        customize()
    elif command == "power":
        power()
    else:
        raise ValueError("Usage: niri-desktop [init|pick|random|apply FILE|settings|power|bar]")


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, subprocess.CalledProcessError) as error:
        print(error, file=sys.stderr)
        if os.environ.get("WAYLAND_DISPLAY"):
            run("notify-send", f"{PREFIX.capitalize()} desktop", str(error), check=False)
        sys.exit(1)
