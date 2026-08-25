```
# NouTube Desktop Flake

Standalone, automated Nix Flake for [NouTube Desktop](https://github.com/nonbili/NouTube-Desktop). Wraps the application using system Electron for native Wayland performance.

Sources and dependency hashes are automatically updated daily via `nvfetcher` and GitHub Actions.

## Quick Try

Run NouTube directly without installation:

```bash
nix run github:pirate-boop/NouTube-Desktop-flake

```

## Installation

Add the repository to your `flake.nix` inputs:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    noutube.url = "github:pirate-boop/NouTube-Desktop-flake";
  };
}

```

### Method 1: System Overlay (Recommended)

Injects `noutube` into `pkgs`, making it available everywhere across NixOS and Home Manager:

```nix
# NixOS module
{ pkgs, inputs, ... }: {
  nixpkgs.overlays = [
    inputs.noutube.overlays.default
  ];

  environment.systemPackages = [
    pkgs.noutube
  ];
}

```

### Method 2: System Package

Direct package usage without global overlays:

```nix
# NixOS module
{ pkgs, inputs, ... }: {
  environment.systemPackages = [
    inputs.noutube.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}

```

### Method 3: Home Manager

Install strictly for your user profile:

```nix
# home.nix
{ pkgs, inputs, ... }: {
  home.packages = [
    inputs.noutube.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}

```

## Updating

Update NouTube inputs in your system configuration:

```bash
nix flake update noutube

```

---
