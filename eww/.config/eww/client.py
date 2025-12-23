from dataclasses import dataclass, field

@dataclass
class Client:
    address: str
    workspace_id: str
    class_name: str
    icon_path: str

    def __post_init__(self):
        """Clean up the address by removing 0x prefix if present."""
        if self.address.startswith("0x"):
            self.address = self.address.removeprefix("0x")
