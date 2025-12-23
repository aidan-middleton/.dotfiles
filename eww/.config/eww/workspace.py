from dataclasses import dataclass, field

@dataclass
class Workspace:
    """Represents a workspace in Hyprland."""
    id: int
    name: str
    monitor: str
    monitor_id: int
    is_active: bool = False
    client_icons: list[str] = field(default_factory=list)
    is_special: bool = False
    
    def add_client_icon(self, icon_path: str) -> None:
        """Add a client icon to this workspace."""
        self.client_icons.append(icon_path)
    
    def remove_client_icon(self, icon_path: str) -> None:
        """Remove a client icon from this workspace."""
        if icon_path in self.client_icons:
            self.client_icons.remove(icon_path)
    
    def clear_clients(self) -> None:
        """Remove all client icons from this workspace."""
        self.client_icons.clear()
    
    @property
    def has_clients(self) -> bool:
        """Check if this workspace has any clients."""
        return len(self.client_icons) > 0
    
    def to_dict(self) -> dict:
        """Convert workspace to dictionary format for JSON output."""
        return {
            "id": self.id,
            "name": self.name,
            "monitor": self.monitor,
            "monitorID": self.monitor_id,
            "isActive": self.is_active,
            "clients": self.client_icons.copy()
        }
    
    @classmethod
    def from_hyprctl_data(cls, data: dict) -> 'Workspace':
        """Create a Workspace from hyprctl JSON data."""
        return cls(
            id=data["id"],
            name=data["name"],
            monitor=data["monitor"],
            monitor_id=data["monitorID"],
            is_active=False,  # Will be set separately based on monitor state
            client_icons=[],
            is_special=data["id"] < 0  # Special workspaces have negative IDs
        )
    
    @classmethod
    def from_monitor_data(cls, monitor_data: dict, workspace_data: dict) -> 'Workspace':
        """Create a Workspace from monitor's active workspace data."""
        return cls(
            id=workspace_data["id"],
            name=workspace_data["name"],
            monitor=monitor_data["name"],
            monitor_id=monitor_data["id"],
            is_active=True,
            client_icons=[]
        )
