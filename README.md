```markdown
# NouTube Desktop Flake

Standalone, automated Nix Flake for [NouTube Desktop](https://github.com/nonbili/NouTube-Desktop). It wraps the application using system Electron for native Wayland performance without Flatpak or AppImage overhead.

Sources and dependency hashes are automatically updated daily via `nvfetcher` and GitHub Actions.

**Quick Try (Without Installation)**

Run NouTube directly without modifying your system configuration:

```bash
nix run github:pirate-boop/NouTube-Desktop-flake

```

**Installation**

Add the repository to your `flake.nix` inputs:

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    noutube.url = "github:pirate-boop/NouTube-Desktop-flake";
  };

  outputs = { self, nixpkgs, noutube, ... }: {
    # System or Home Manager output configurations
  };
}

```

Choose one of the following installation methods:

**Method 1: System Overlay (Recommended)**

Using the overlay is the cleanest approach. It injects `noutube` into `pkgs`, making it natively accessible across NixOS and Home Manager configurations.

```nix
# In your NixOS configuration module
{ pkgs, inputs, ... }: {
  nixpkgs.overlays = [
    inputs.noutube.overlays.default
  ];

  # Package is now available directly in pkgs scope
  environment.systemPackages = [
    pkgs.noutube
  ];
}

```

**Method 2: System Package (Direct Input)**

If you prefer referencing flake outputs directly without altering global overlays:

```nix
# In your NixOS configuration module
{ pkgs, inputs, ... }: {
  environment.systemPackages = [
    inputs.noutube.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}

```

**Method 3: Home Manager**

To install the package strictly for your individual user profile:

```nix
# In your home.nix module
{ pkgs, inputs, ... }: {
  home.packages = [
    inputs.noutube.packages.${pkgs.stdenv.hostPlatform.system}.default
    # Or 'pkgs.noutube' if system overlay is enabled
  ];
}

```

**Updating**

Upstream updates are fetched automatically every 24 hours. To update NouTube on your system, execute:

```bash
nix flake update noutube

```

```

```