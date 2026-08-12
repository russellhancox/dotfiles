My dotfiles
===========

A collection of my dotfiles that I check out on computers I own/use regularly.
Managed by [nix-darwin](https://github.com/nix-darwin/nix-darwin) and
[home-manager](https://github.com/nix-community/home-manager).

macOS gets the full treatment: packages, Homebrew casks and system defaults.
Linux gets the dotfiles only, via standalone home-manager.

Bootstrap a new machine
-----------------------

Both platforms start the same way:

```sh
curl -L https://nixos.org/nix/install | sh -s -- --daemon
exec $SHELL -l
git clone https://github.com/<you>/dotfiles ~/.dotfiles
```

The first switch has to enable flakes by hand, because the setting that enables
them permanently is itself inside the config.

macOS:

```sh
sudo nix run --extra-experimental-features 'nix-command flakes' \
  github:nix-darwin/nix-darwin/master#darwin-rebuild -- \
  switch --flake ~/.dotfiles#mac
```

Linux needs the env var rather than the flag: `home-manager` shells out to its
own `nix` subprocesses, and they don't inherit command-line flags.

```sh
export NIX_CONFIG="experimental-features = nix-command flakes"
nix run home-manager/master -- \
  switch -b hm-bak --flake ~/.dotfiles#linux-$(uname -m)
```

That installs zsh but can't make it the login shell - `/etc/passwd` is outside
what standalone home-manager manages.
`chsh` also refuses any shell missing from `/etc/shells`, and a Nix-installed
one won't be there, so it needs adding first:

```sh
command -v zsh | sudo tee -a /etc/shells
chsh -s "$(command -v zsh)"
```

Nix only reads git-tracked files inside a flake repo, so commit any new file
before switching or it will be invisible.

Apply changes
-------------

`nix-rebuild` is aliased to the right command for the platform:

```sh
nix-rebuild
```

Layout
------

| File | Owns |
| --- | --- |
| `flake.nix` | Inputs, `darwinConfigurations.mac`, `homeConfigurations.linux-*` |
| `darwin.nix` | Packages (nixpkgs + homebrew) and macOS defaults. Not used on Linux |
| `home.nix` | Symlinks the config files below into `$HOME`, both platforms |

The config files themselves stay plain: `zshrc`, `gitconfig`, `tmux.conf`,
`vimrc`, `vim/`, `hammerspoon/`, `lldbinit`, `ls_colors`, and `config/*` for
nvim, starship, ghostty and whosthere.
They are linked out of the store, so editing them here takes effect immediately
with no rebuild.

`hammerspoon/` and `Avatar.jpg` are linked on macOS only.
Commit signing is split into `gitconfig-darwin` and `gitconfig-linux`, since the
1Password signer sits at a different path on each, and `gitconfig` pulls the
right one in through `[include] path = ~/.gitconfig.os`.
