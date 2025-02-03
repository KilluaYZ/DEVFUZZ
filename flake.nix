{
  description = "A very basic flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "https://github.com/NixOS/nixpkgs/tarball/nixos-24.11";
  };

  outputs = { self, nixpkgs }: 
  let 
    pkgs = import nixpkgs { system = "x86_64-linux"; config = {}; overlays = []; };
  in 
  rec {

    # stdenv环境
    stdenv = pkgs.stdenv;
    clangStdenv = pkgs.clangStdenv;
    llvmStdenv = pkgs.llvmPackages_13.stdenv;

    # ------------------ 编译afl-proxy ------------------------
    aflProxyDrv = stdenv.mkDerivation {
      name = "devfuzz_afl_proxy";
      src = ./afl-proxy/.;

      nativeBuildInputs = with pkgs; [
       llvmPackages_13.libcxxClang gcc pkg-config cmake
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

    # ----------------------------------------------------------


    # ------------------ 编译AFL ------------------------

    aflDrv = stdenv.mkDerivation {
      name = "devfuzz_afl";
      src = ./AFL/.;

      nativeBuildInputs = with pkgs; [
       llvmPackages_13.libcxxClang 
      ];

      buildInputs = with pkgs; [
       
      ];

      preBuild = ''
        export CC=${pkgs.llvmPackages_13.libcxxClang }/bin/clang
        export CXX=${pkgs.llvmPackages_13.libcxxClang }/bin/clang++
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p $out/AFL/
        cp -r ./* $out/AFL/
        runHook postInstall
      '';

      buildPhase = ''
        runHook preBuild
        make -j
        runHook postBuild
      '';
    };  
    packages.x86_64-linux.afl = aflDrv;

    

    devShells.x86_64-linux.default = pkgs.mkShell {
      packages = with pkgs; [
        gcc llvmPackages_13.libcxxClang cmake 
      ];
    };

  };
}
