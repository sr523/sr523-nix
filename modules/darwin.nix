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
      tilesize = 32; # small icons on the Dock
    };

    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXPreferredViewStyle = "Nlsv"; # list view for files/folders
      CreateDesktop = false; # hide all icons on the desktop
    };

    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark"; # force dark mode
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      _HIHideMenuBar = true; # auto-hide the menu bar (toolbar)
    };
  };

  # --- Night Shift (always on) ----------------------------------------------
  # nix-darwin has no declarative option for Night Shift, so drive the
  # `nightlight` CLI (installed via Homebrew) on each activation. A schedule of
  # 3:00 -> 2:59 keeps Night Shift active ~24h/day.
  system.activationScripts.nightShift.text = ''
    NIGHTLIGHT=/opt/homebrew/bin/nightlight
    if [ -x "$NIGHTLIGHT" ]; then
      sudo -u ${username} "$NIGHTLIGHT" schedule 3:00 2:59 || true
      sudo -u ${username} "$NIGHTLIGHT" on || true
    fi
  '';

  # --- State version ---------------------------------------------------------
  # Do not change after first switch unless you know why.
  system.stateVersion = 6;
}
