{ system ? builtins.currentSystem
, rust-overlay ? import (builtins.fetchTarball {
    url = https://github.com/oxalica/rust-overlay/archive/fb8b1172e450433c59d8cb4c6e2a3e19c78dff4f.tar.gz;
    sha256 = "142k1y0rpbc0q6cxm53r3kkkp8j5hqsd9rsjc4q9ndfdyvqd2qch";
  })
, pkgs ? (import <nixpkgs> {
    inherit system;
    overlays = [ rust-overlay ];
  })
}:
let
rustPlatform = pkgs.makeRustPlatform {
    rustc = pkgs.rust-bin.nightly."2021-10-21".rust;
    cargo = pkgs.rust-bin.nightly."2021-10-21".cargo;
};
in
rustPlatform.buildRustPackage rec {
  pname = "fortanix-sgx-tools";
  version = "0.8.5";

  src = ./.;
  buildAndTestSubdir = "fortanix-sgx-tools";

  nativeBuildInputs = with pkgs; [cmake pkg-config openssl protobuf];
  buildInputs = [ pkgs.openssl ];

  cargoSha256 = "TsH5sxcTBlFVl4K88xkYL/2iSAMp4vSynZPBO5VNlg4=";

  meta = with pkgs.stdenv.lib; {
    description = "fortanix-sgx-tools";
  };
}
