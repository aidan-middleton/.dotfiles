import os
import subprocess
from dataclasses import dataclass, field

@dataclass
class Icon:
    path: str

class IconManager:
    """
    see: https://specifications.freedesktop.org/icon-theme-spec/0.13
    """
   
    cmd = "gsettings get org.gnome.desktop.interface icon-theme"

    icon_formats = [ "PNG", "SVG", "XMP"]
  
    default_theme = "hicolor"

    def __init__(self):
        self.theme = self.get_theme()

    @property
    def icon_search_paths(self) -> list[str]:
        home = os.path.expanduser("~")
        xdg_data_dirs = os.environ.get("XDG_DATA_DIRS")
        if not xdg_data_dirs:
            xdg_data_dirs = "/usr/local/share:/usr/share"
        xdg_data_paths = xdg_data_dirs.split(":")
        search_paths = [
            os.path.join(home, ".icons"),
            *[os.path.join(path, "icons") for path in xdg_data_paths],
            "/usr/share/pixmaps"
        ]
        return search_paths
    
    @property
    def theme(self) -> str:
        theme = None
        try:
            result = subprocess.run(
                self.cmd.split(),
                capture_output=True,
                text=True,
                check=True
            )
            theme = result.stdout.strip().replace("'","")
        except subprocess.CalledProcessError as e:
            print("Command failed:", e)
        return theme or self.default_theme

    def get_theme(self) -> str | None:
        icon_theme = None
        try:
            result = subprocess.run(
                self.cmd.split(),
                capture_output=True,
                text=True,
                check=True
            )
            icon_theme = result.stdout.strip().replace("'","")
        except subprocess.CalledProcessError as e:
            print("Command failed:", e)
        return icon_theme

def get_icon(client: str) -> str:
    # Get default icon theme
    default_path = "/usr/share/icons/default/index.theme"
    default_icon_theme = None
    try:
        with open(default_path, "r", encoding="utf-8") as f:
           for line in f:
                if line.startswith("Inherits="):
                    default_icon_theme = line.strip().split("=", 1)[1]
                    break
    except IOError as e:
        print("Command failed:", e)
    # Get the path the the .destkop file correspond to this icon
    desktop_dirs = [
        "/usr/share/applications/",
        "/usr/local/share/applications/",
        "~/.local/share/applications/",
    ] 
    desktop_path = None
    for dir in desktop_dirs:
        path = os.path.join(dir, f"{client}.desktop")
        if os.path.isfile(path):
            desktop_path = path
            break
    # Get the icon name
    default_icon_name = "application-default-icon" 
    icon_name = default_icon_name
    if desktop_path:
        with open(desktop_path, "r", encoding="utf-8") as f:
            for line in f:
                if line.startswith("Icon="):
                    icon_name = line.strip().split("=", 1)[1]
                    break
    # Generate paths from icon name. (Fall back on defualt them and then default icon.)
    icon_paths = [ 
        f"/usr/share/icons/{icon_theme}/16x16/apps/{icon_name}.svg",
        f"/usr/share/icons/{icon_theme}/16x16/apps/{icon_name}.png",
        f"/usr/share/icons/{default_icon_theme}/16x16/apps/{icon_name}.svg",
        f"/usr/share/icons/{default_icon_theme}/16x16/apps/{icon_name}.png",
        f"/usr/share/icons/{icon_theme}/16x16/apps/{default_icon_name}.svg",
        f"/usr/share/icons/{icon_theme}/16x16/apps/{default_icon_name}.png",
        f"/usr/share/icons/{default_icon_theme}/16x16/apps/{default_icon_name}.svg",
        f"/usr/share/icons/{default_icon_theme}/16x16/apps/{default_icon_name}.png",
    ]
    # Check in order of fall backs for icon theme.
    icon_path = ""
    for path in icon_paths:
        if os.path.exists(path):
            icon_path = path
            break
    return icon_path


