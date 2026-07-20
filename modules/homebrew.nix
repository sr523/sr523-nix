{ ... }:

{
  # nix-darwin's declarative Homebrew management. nix-homebrew (configured in
  # flake.nix) installs/owns the brew binary; this module declares what gets
  # installed and how brew is kept in sync.
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # "zap" removes anything not listed below. Use "uninstall" to be less
      # aggressive, or "none" to leave manually-installed packages alone.
      cleanup = "none";
    };

    # Third-party taps. (homebrew/core and homebrew/cask are built in.)
    taps = [
      "atlassian/acli"
      "derailed/k9s"
      "hashicorp/tap"
      "huseyinbabal/tap"
      "kreuzwerker/taps"
      "pantheon-systems/external"
      "smudge/smudge"
    ];

    # CLI tools (formulae).
    brews = [
      "aider"
      "atlassian/acli/acli"
      "awscli"
      "chamber"
      "colima"
      "docker"
      "docker-compose"
      "gh"
      "glow"
      "helix"
      "helm"
      "herdr"
      "hf"
      "huseyinbabal/tap/taws"
      "kind"
      "kube-ps1"
      "neovim"
      "ollama"
      "opencode"
      "openssh"
      "php"
      "pipx"
      "pre-commit"
      "pyenv"
      "hashicorp/tap/terraform"
      "tmux"
      "valkey"
      "zsh"
    ];

    # GUI apps (casks).
    casks = [
      "claude-code"
      "dbeaver-community"
      "ghostty"
      "openra"
      "visual-studio-code"
    ];

    # Mac App Store apps (requires `mas`). Add entries like:
    # masApps = { "Xcode" = 497799835; };
    masApps = { };
  };
}
