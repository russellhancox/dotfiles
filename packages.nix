# Packages wanted on every machine, regardless of OS.
#
# darwin.nix appends its macOS-only extras to this and installs the lot
# system-wide. home.nix uses it as-is for home.packages on Linux, where there
# is no system-level config to hang them off.
#
# Anything that turns out to be macOS-only, or too heavy for a Linux box, moves
# to the extras list in darwin.nix.

pkgs:

let
  # Not in nixpkgs. The npm tarball is one bundled JS file with no runtime deps,
  # so no lockfile needed. Bump version and hash together.
  ccstatusline = pkgs.stdenvNoCC.mkDerivation {
    name = "ccstatusline-2.2.27";
    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/ccstatusline/-/ccstatusline-2.2.27.tgz";
      hash = "sha256-T2Cb3tENjBBkUWzvuQLtWTkasru6l9WT6KEtB+LaWMI=";
    };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    installPhase = ''
      install -Dm644 dist/ccstatusline.js $out/lib/cc.js
      makeWrapper ${pkgs.nodejs}/bin/node $out/bin/ccstatusline \
        --add-flags $out/lib/cc.js
    '';
  };
in
with pkgs; [
  act
  autojump
  awscli2
  bazel-buildtools # buildifier
  bazelisk
  btop
  buf
  ccache
  ccstatusline
  clang-tools # clang-format
  cloc
  cmake
  cosign
  curl
  duckdb
  eza
  ffmpeg
  fswatch
  fzf
  gh
  git
  git-lfs
  glow
  gnupg
  go
  go-migrate # golang-migrate
  go-task
  gopls
  goreleaser
  graphviz
  grpcurl
  htop
  jq
  lefthook
  neovim
  nmap
  nodejs
  pipx
  pngcrush
  protoc-gen-go
  protoc-gen-go-grpc
  protoc-gen-grpc-web
  pstree
  pv
  pyenv
  pylint
  qrencode
  rbenv
  ripgrep
  rustup
  s3cmd
  sqlc
  sslscan
  starship
  tig
  tmux
  tree
  upx
  uv
  vim
  wakeonlan
  wget
  whisper-cpp
  yamllint
  zsh-autosuggestions
  zsh-syntax-highlighting
]
