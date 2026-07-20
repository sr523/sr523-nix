{ pkgs, username, ... }:

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
  ];

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
