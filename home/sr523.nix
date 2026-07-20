{ pkgs, lib, config, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/Users/${username}";

  # Keep in sync with your first install; don't bump casually.
  home.stateVersion = "24.11";

  # Let home-manager manage itself.
  programs.home-manager.enable = true;

  # --- User packages (Nix-managed) ------------------------------------------
  # Prefer Homebrew (see modules/homebrew.nix) for most tools per this
  # project's setup. Put small, Nix-friendly extras here.
  home.packages = with pkgs; [
    # LazyVim runtime dependencies. Neovim itself is installed via Homebrew.
    ripgrep # required by Telescope live-grep
    fd # faster file finding
    gcc # C compiler for building treesitter parsers
    gnumake
    lazygit # LazyVim's built-in git UI (<leader>gg)
    tree-sitter
    nodejs # many LSP servers / mason tools need node
  ];

  # --- LazyVim ---------------------------------------------------------------
  # LazyVim manages its own plugins at runtime via lazy.nvim, so its config dir
  # must be writable (home-manager symlinks into the read-only nix store won't
  # work). We bootstrap the official starter once; after that the directory is
  # yours to edit/version-control. Delete ~/.config/nvim to re-bootstrap.
  home.activation.lazyvim = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    NVIM_CONFIG="${config.xdg.configHome}/nvim"
    if [ ! -e "$NVIM_CONFIG/init.lua" ]; then
      run ${pkgs.git}/bin/git clone --depth 1 \
        https://github.com/LazyVim/starter "$NVIM_CONFIG"
      run rm -rf "$NVIM_CONFIG/.git"
    fi
  '';

  # --- Pi coding agent -------------------------------------------------------
  # Pi (https://pi.dev) is a minimal, extensible agentic coding assistant
  # distributed on npm as @earendil-works/pi-coding-agent. It isn't in nixpkgs
  # or Homebrew yet, so we install it globally with the Nix-managed nodejs.
  # The `--ignore-scripts` flag matches the vendor's recommended npm install.
  # Re-runs on every activation to keep it up to date; remove ~/.pi to reset.
  home.activation.pi = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${pkgs.nodejs}/bin:$PATH"
    run ${pkgs.nodejs}/bin/npm install -g --ignore-scripts \
      @earendil-works/pi-coding-agent
  '';

  # --- Git -------------------------------------------------------------------
  programs.git = {
    enable = true;
    userName = "Scott Ross";
    userEmail = "sr523@cornell.edu";
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  # --- Zsh -------------------------------------------------------------------
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      # Rebuild + switch this flake from anywhere.
      drs = "darwin-rebuild switch --flake ~/Documents/src/sross-nix";
    };
  };
}
