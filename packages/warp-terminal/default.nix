{ lib
, stdenvNoCC
, stdenv
, fetchurl
, undmg
, appimageTools
, zstd
, autoPatchelfHook
, curl
, fontconfig
, xorg
, libxkbcommon
, xdg-utils
, zlib
, libglvnd
, vulkan-loader
}:

let
  pname = "warp-terminal";

  version = "0.2024.02.20.08.01.stable_02";

  linux = stdenv.mkDerivation rec {
    inherit pname version meta;
    src = fetchurl {
      url = "https://releases.warp.dev/stable/v${version}/warp-terminal-v${version}-1-x86_64.pkg.tar.zst";
      hash = "sha256-u3VZ2l2ec8UHzt4tOJgnn98HiASSWJAQwBRdoaR/aO4=";
    };

    nativeBuildInputs = [ autoPatchelfHook zstd ];

    buildInputs = [
      curl
      vulkan-loader
      fontconfig
      libglvnd # for libegl
      xorg.libX11
      xorg.libxcb
      xorg.libXcursor
      xorg.libXi
      libxkbcommon
      xdg-utils
      stdenv.cc.cc.lib # libstdc++.so libgcc_s.so
      zlib
    ];

    sourceRoot = ".";

    runtimeDependencies = buildInputs;

    installPhase = ''
      runHook preInstall

      mkdir $out
      mv * $out/
      mv  $out/usr/* $out/
      rm -r $out/usr

      substituteInPlace $out/bin/warp-terminal \
        --replace-fail /opt/ $out/opt/

      runHook postInstall
    '';
  };

  darwin = stdenvNoCC.mkDerivation (finalAttrs: {
    inherit pname version meta;
    src = fetchurl {
      url = "https://releases.warp.dev/stable/v${finalAttrs.version}/Warp.dmg";
      hash = "sha256-9olAmczIPRXV15NYCOYmwuEmJ7lMeaQRTTfukaYXMR0=";
    };

    sourceRoot = ".";

    nativeBuildInputs = [ undmg ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r *.app $out/Applications

      runHook postInstall
    '';
  });

  meta = with lib; {
    description = "Rust-based terminal";
    homepage = "https://www.warp.dev";
    license = licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ emilytrau Enzime ];
    platforms = platforms.darwin ++ [ "x86_64-linux" ];
  };

in
if stdenvNoCC.isDarwin
then darwin
else linux
