# sross-nix

Declarative macOS configuration for `VMIT-FMGHQYVHM6` (Apple Silicon) using
[nix-darwin](https://github.com/LnL7/nix-darwin),
[home-manager](https://github.com/nix-community/home-manager), and
[nix-homebrew](https://github.com/zhaofengli/nix-homebrew).

Homebrew is the primary package manager; Nix orchestrates it declaratively.

## Layout

```
flake.nix            # inputs + darwinConfigurations wiring
modules/darwin.nix   # system-level macOS config
modules/homebrew.nix # taps / brews / casks / masApps
home/sr523.nix       # home-manager user config (git, zsh, packages)
```

## Prerequisites

Install Nix (with flakes). Recommended:

```sh
curl --proto '=https' --tlsv1.2 -sSf -L \
  https://install.determinate.systems/nix | sh -s -- install
```

Open a new shell afterward so `nix` is on your PATH.

> `nix.enable = false` is set in `modules/darwin.nix` because the Determinate
> installer manages the daemon. If you used the official multi-user installer
> and want nix-darwin to manage the daemon, remove that line.

## First build

nix-darwin isn't installed yet, so bootstrap with `nix run`:

```sh
cd ~/Documents/src/sross-nix
nix run nix-darwin -- switch --flake .#VMIT-FMGHQYVHM6
```

`nix-homebrew` is configured with `autoMigrate = true`, so it adopts your
existing `/opt/homebrew` install rather than reinstalling it.

## Day-to-day

After the first switch, `darwin-rebuild` is available:

```sh
darwin-rebuild switch --flake ~/Documents/src/sross-nix
# or the alias defined in home/sr523.nix:
drs
```

## Validate without applying

```sh
nix flake check
darwin-rebuild build --flake .#VMIT-FMGHQYVHM6   # after nix-darwin is installed
```

## Adding packages

- CLI tools -> `brews` in `modules/homebrew.nix`
- GUI apps  -> `casks` in `modules/homebrew.nix`
- Taps      -> `taps` in `modules/homebrew.nix`
- User dotfiles / Nix packages -> `home/sr523.nix`
- System settings -> `modules/darwin.nix`
