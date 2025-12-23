from dataclasses import dataclass, field

@dataclass
class Monitor:
    """Represents a monitor in Hyprland."""
    name: str
    id: int
    is_focused: bool = False
    active_workspace_id: int | None = None
    special_workspace_id: int | None = None
    
    @property
    def has_special_workspace(self) -> bool:
        """Check if this monitor has an active special workspace."""
        return self.special_workspace_id is not None and self.special_workspace_id != 0
