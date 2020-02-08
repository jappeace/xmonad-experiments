{}:
let 
  hostPkgs = import <nixpkgs> {};
  pinnedPkgs = hostPkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs-channels";
    # nixos-stable 19.03  of 11.04.2019
    rev = "5c52b25283a6cccca443ffb7a358de6fe14b4a81";
    sha256 = "0fhbl6bgabhi1sw1lrs64i0hibmmppy1bh256lq8hxy3a2p1haip";
  };
in
import pinnedPkgs {
  config.allowUnfree = true;
}
