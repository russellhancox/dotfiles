{ config, lib, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";

  # ponytail: out-of-store symlinks, not store copies. Every one of these is
  # edited in place, and some are written by tools (git writes to gitconfig,
  # lazy.nvim to lazy-lock.json, vim-plug into ~/.vim). A read-only store path
  # would break that. Costs purity, keeps the edit-and-reload loop.
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  home.stateVersion = "25.05";

  # Needed on Linux, where this is a standalone config driven by the
  # home-manager CLI. On darwin the nix-darwin module drives it instead.
  programs.home-manager.enable = pkgs.stdenv.isLinux;

  # macOS gets its packages from darwin.nix. Linux has no system-level config,
  # so anything the linked dotfiles hard-depend on has to come from here.
  # Not programs.zsh.enable - that module generates its own ~/.zshrc and would
  # collide with the symlink below. Making it the login shell is a chsh step,
  # see the README; standalone home-manager doesn't manage /etc/passwd.
  home.packages = lib.optionals pkgs.stdenv.isLinux (
    (import ./packages.nix pkgs) ++ (with pkgs; [
      # macOS ships zsh and darwin.nix takes the brew one; Linux needs it here.
      zsh
    ])
  );

  home.file = {
    ".zshrc".source = link "zshrc";
    ".gitconfig".source = link "gitconfig";
    ".gitignore".source = link "gitignore";
    ".tmux.conf".source = link "tmux.conf";
    ".vimrc".source = link "vimrc";
    ".vim".source = link "vim";
    ".lldbinit".source = link "lldbinit";
    ".ls_colors".source = link "ls_colors";

    # Individual paths only - ~/.claude also holds .credentials.json, a large
    # history.jsonl and debug logs, none of which belong in a repo.
    ".claude/CLAUDE.md".source = link "claude/CLAUDE.md";
    ".claude/settings.json".source = link "claude/settings.json";
    ".claude/sounds".source = link "claude/sounds";

    # zshrc sources these by stable path rather than shelling out to
    # `brew --prefix` twice on every shell start.
    ".zsh/plugins/zsh-autosuggestions.zsh".source =
      "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh";
    ".zsh/plugins/zsh-syntax-highlighting.zsh".source =
      "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
  }
  # Picked up by gitconfig's [include]. Only the signer path differs.
  // lib.optionalAttrs pkgs.stdenv.isDarwin {
    ".gitconfig.os".source = link "gitconfig-darwin";

    # Darwin-only: every path in it is a macOS one. Read by ripgrep and by
    # Claude Code's workspace scan, which crawls the whole tree when started in
    # ~ (not a git repo, so nothing prunes it) and bangs on every TCC-protected
    # directory on the way past.
    ".ignore".source = link "ignore";

    # Hammerspoon is macOS-only, and Avatar.jpg exists so the account picture
    # can be chosen from ~/Pictures in System Settings.
    ".hammerspoon".source = link "hammerspoon";
    "Pictures/Avatar.jpg".source = link "Avatar.jpg";
  }
  // lib.optionalAttrs pkgs.stdenv.isLinux {
    ".gitconfig.os".source = link "gitconfig-linux";
  };

  xdg.configFile = {
    "nvim".source = link "config/nvim";
    "starship".source = link "config/starship";
    "ghostty".source = link "config/ghostty";
    "whosthere".source = link "config/whosthere";

    # Just the config - herdr keeps its sockets, logs, session state and
    # installed plugins in the same directory.
    "herdr/config.toml".source = link "config/herdr/config.toml";
  }
  // lib.optionalAttrs pkgs.stdenv.isLinux {
    # darwin.nix's nix.settings writes /etc/nix/nix.conf. Standalone
    # home-manager manages nothing system-wide, so flakes get enabled per-user
    # here - otherwise every switch after the first needs the flag passed again.
    "nix/nix.conf".text = ''
      experimental-features = nix-command flakes
    '';
  };
}
