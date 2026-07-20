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

> On a fresh machine the `nix-command` and `flakes` experimental features may
> not be enabled yet, producing an error like
> `experimental Nix feature 'nix-command' is disabled`. Enable them for the
> single command with:
>
> ```sh
> nix --extra-experimental-features "nix-command flakes" \
>   run nix-darwin -- switch --flake .#VMIT-FMGHQYVHM6
> ```
>
> (nix-darwin enables these permanently once the first switch completes.)

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

## Installed packages

Since this is primarily a development configuration, the installed packages are
grouped by purpose below. Package sources: `modules/homebrew.nix` (brews/casks)
and `home/sr523.nix` (Nix-managed).

### Terminal tools

| Package | Description |
| --- | --- |
| `ghostty` | GPU-accelerated terminal emulator (cask) |
| `tmux` | Terminal multiplexer |
| `zsh` | Z shell (with autosuggestions + syntax highlighting via home-manager) |
| `kube-ps1` | Kubernetes context/namespace prompt segment |
| `ripgrep` | Fast recursive search (`rg`) |
| `fd` | Fast file finder |
| `glow` / `hf` | Markdown renderer / Hugging Face CLI |
| `openssh` | SSH client/server |

### Text editors

| Package | Description |
| --- | --- |
| `neovim` | Neovim, bootstrapped with the LazyVim starter |
| `helix` | Modal post-modern text editor |
| `visual-studio-code` | Visual Studio Code (cask) |
| `lazygit` | Terminal git UI (LazyVim `<leader>gg`) |
| `tree-sitter` | Incremental parsing library for editor syntax highlighting |

### Infrastructure (k8s, AWS)

| Package | Description |
| --- | --- |
| `awscli` | AWS command-line interface |
| `taws` | AWS helper CLI (huseyinbabal tap) |
| `chamber` | AWS SSM-backed secrets management |
| `terraform` | Infrastructure as code |
| `helm` | Kubernetes package manager |
| `kind` | Kubernetes in Docker (local clusters) |
| `k9s` | Kubernetes TUI (derailed tap) |
| `colima` | Container runtime for macOS |
| `docker` / `docker-compose` | Container tooling |
| `valkey` | Redis-compatible in-memory data store |

### Language-specific / build tools

| Package | Description |
| --- | --- |
| `gcc` | C compiler (builds treesitter parsers) |
| `gnumake` | GNU Make |
| `nodejs` | Node.js runtime (LSP servers / mason tools) |
| `php` | PHP runtime |
| `pyenv` | Python version manager |
| `pipx` | Install Python CLI apps in isolated envs |
| `pre-commit` | Git pre-commit hook framework |

### AI-assisted programming (agentic)

| Package | Description |
| --- | --- |
| `opencode` | Terminal-based agentic coding assistant |
| `claude-code` | Anthropic's agentic coding CLI (cask) |
| `aider` | AI pair programming in the terminal |
| `ollama` | Run local LLMs |

### Other

| Package | Description |
| --- | --- |
| `gh` | GitHub CLI |
| `git` | Version control (configured via home-manager) |
| `acli` | Atlassian CLI |
| `herdr` | Herd runner utility |
| `dbeaver-community` | Database GUI client (cask) |
| `openra` | Open-source Command & Conquer engine (cask) |

## Adding packages

- CLI tools -> `brews` in `modules/homebrew.nix`
- GUI apps  -> `casks` in `modules/homebrew.nix`
- Taps      -> `taps` in `modules/homebrew.nix`
- User dotfiles / Nix packages -> `home/sr523.nix`
- System settings -> `modules/darwin.nix`
