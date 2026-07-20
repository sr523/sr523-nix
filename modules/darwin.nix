{ pkgs, inputs, username, hostname, ... }:

{
  # --- Nix daemon / flakes ---------------------------------------------------
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Let Determinate / the Nix installer manage the daemon. If you used the
  # official multi-user installer and want nix-darwin to manage it, set this
  # back to the default. With the Determinate Systems installer, keep it off.
  nix.enable = false;

  # --- Platform --------------------------------------------------------------
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # --- Users -----------------------------------------------------------------
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  # The user that owns the primary Homebrew prefix / does GUI installs.
  system.primaryUser = username;

  networking.hostName = hostname;
  networking.computerName = hostname;

  # --- System-wide packages (Nix, not Homebrew) -----------------------------
  # Keep this lean — Homebrew handles most tools per the project setup.
  environment.systemPackages = with pkgs; [
    git
  ];

  # --- Shells ----------------------------------------------------------------
  programs.zsh.enable = true;

  # --- macOS system defaults -------------------------------------------------
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 48;
    };

    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXPreferredViewStyle = "Nlsv"; # list view
    };

    NSGlobalDomain = {
      AppleInterfaceStyleSwitchesAutomatically = true;
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
    };
  };

  # --- State version ---------------------------------------------------------
  # Do not change after first switch unless you know why.
  system.stateVersion = 6;
}
