{ pkgs, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = 6;
  system.primaryUser = "rah";
  users.users.rah.home = "/Users/rah";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Manages /etc/zshrc so the nix profile lands on PATH in login shells.
  # Our own ~/.zshrc is still sourced afterwards.
  programs.zsh.enable = true;

  #############################################################################
  # Packages
  #############################################################################

  # The shared list, plus the macOS-only extras.
  environment.systemPackages = (import ./packages.nix pkgs) ++ (with pkgs; [
    # Prefixed (gls, gdate, gstat...) so GNU tools don't shadow the BSD ones.
    # Plain coreutils would put GNU ls ahead of /bin/ls, and GNU ls has no -O,
    # which is how macOS file flags get shown. Matches what brew did by default.
    coreutils-prefixed

    create-dmg
    terminal-notifier
  ]);

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # ponytail: "none" until the nixpkgs list above is proven on a real rebuild.
      # Flip to "uninstall" (or "zap" to also drop app data) to make the list
      # authoritative and have brew prune everything not named here.
      cleanup = "none";
    };

    taps = [
      "bufbuild/buf"
    ];

    # Things nixpkgs doesn't have, or that behave badly on darwin under nix
    # (versioned toolchains, tools that shadow system binaries, stateful CLIs).
    brews = [
      "bgrep"
      "binutils"
      "clang-format@11"
      "e2fsprogs"
      "git-remote-codecommit"
      "grip"
      "herdr"
      "inetutils"
      "llvm@19"
      "ratchet"
      "swift-format"
      "trash"
      "vcpkg"
      "virtualenv"
      "watch"
      "whosthere"
      "zsh"
    ];

    casks = [
      "1password"
      "1password-cli"
      "alfred"
      "brewy"
      "coderunner"
      "gcloud-cli"
      "ghostty"
      "hammerspoon"
      "meetingbar"
      "ngrok"
      "orbstack"
      "postico"
      "slack"
      "zed"
    ];
  };

  #############################################################################
  # macOS defaults
  #############################################################################

  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleFontSmoothing = 2;
      AppleKeyboardUIMode = 3; # Tab reaches every control, incl. modal dialogs
      ApplePressAndHoldEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSNavPanelExpandedStateForSaveMode = true;
      PMPrintingExpandedStateForPrint = true;
      "com.apple.mouse.tapBehavior" = 1;
    };

    controlcenter.BatteryShowPercentage = true;

    dock = {
      autohide = true;
      orientation = "left";
      show-recents = false;
      showhidden = true;

      # Replaces default-dock.plist. Anything not listed is removed.
      persistent-apps = [
        "/Applications/Google Chrome.app"
        "/Applications/Slack.app"
        "/System/Applications/Messages.app"
        "/System/Applications/Notes.app"
        "/Applications/Ghostty.app"
        "/Applications/Insomnia.app"
        "/Applications/Linear.app"
        "/Applications/Zed.app"
        "/Applications/Postico 2.app"
        "/Applications/BambuStudio.app"
        "/Applications/WhatsApp.app"
        "/Applications/CodeRunner.app"
      ];
      persistent-others = [ "/Users/rah/Downloads" ];
    };

    finder = {
      ShowStatusBar = true;
      FXPreferredViewStyle = "Nlsv"; # list view everywhere
      NewWindowTarget = "Home";
    };

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };

    CustomUserPreferences = {
      "com.apple.finder" = {
        QLEnableTextSelection = true;

        # Desktop icon view. Unlike PlistBuddy's leaf-level Set, this replaces
        # the whole subtree, so every key has to be named - the non-obvious
        # ones below are just the macOS defaults, restated.
        DesktopViewSettings.IconViewSettings = {
          showItemInfo = true;
          arrangeBy = "grid";
          iconSize = 64;
          gridSpacing = 54;
          gridOffsetX = 0;
          gridOffsetY = 0;
          textSize = 12;
          labelOnBottom = true;
          showIconPreview = true;
          backgroundType = 0;
          backgroundColorRed = 1;
          backgroundColorGreen = 1;
          backgroundColorBlue = 1;
          viewOptionsVersion = 1;
        };
      };

      "com.apple.desktopservices".DSDontWriteNetworkStores = true;
      "com.apple.print.PrintingPrefs"."Quit When Finished" = true;
      "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
      "com.apple.dt.Xcode".ShowBuildOperationDuration = true;

      # External Magic Trackpad uses a different domain to the built-in one.
      "com.apple.driver.AppleBluetoothMultitouch.trackpad" = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };

    CustomSystemPreferences = {
      "com.apple.windowserver".DisplayResolutionEnabled = true; # HiDPI modes
    };
  };
}
