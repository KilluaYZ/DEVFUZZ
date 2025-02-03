{
  description = "A very basic flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "https://github.com/NixOS/nixpkgs/tarball/nixos-24.11";
  };

  outputs = { self, nixpkgs, fenix }: 
  let 
    pkgs = import nixpkgs { system = "x86_64-linux"; config = {}; overlays = []; };
  in 
  rec {
    stdenv = pkgs.stdenv;
    clangStdenv = pkgs.clangStdenv;
    llvmStdenv = pkgs.llvmPackages_13.stdenv;

    aflProxyDrv = stdenv.mkDerivation {
      name = "devfuzz_afl_proxy";
      src = ./afl-proxy/.;

      nativeBuildInputs = with pkgs; [
       clang gcc pkg-config cmake
      ];

      buildInputs = with pkgs; [
        libxml2 llvmPackages_13.libllvm 
      ];

      configurePhase = ''
       
      '';
      

      preBuild = ''
        export CFLAGS="-I $NIX_BUILD_TOP/afl-proxy/aplib/ -I $NIX_BUILD_TOP/afl-proxy/"
        export QEMU_LDFLAGS="$NIX_BUILD_TOP/afl-proxy/aplib/aplib.so"
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p $out/afl_proxy/
        cp -r ./* $out/afl_proxy/
        runHook postInstall
      '';

      buildPhase = ''
        runHook preBuild
        make -j
        runHook postBuild
      '';
    };

    packages.x86_64-linux.aflProxy = aflProxyDrv;

    devShells.x86_64-linux.default = pkgs.mkShell {
      packages = with pkgs; [
        gcc clang cmake 
      ];
    };

  };
}
