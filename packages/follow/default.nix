{
  lib,
  stdenvNoCC,
  fetchurl,
  appimageTools,
  makeWrapper,
  writeShellApplication,
  curl,
  yq,
  common-updater-scripts,
}:
let
  pname = "follow";
  version = "0.0.1-alpha.10";
  owner = "RSSNext";
  repo = "Follow";
  src = fetchurl {
    url = "https://github.com/${owner}/${repo}/releases/download/v${version}/Follow-${version}-linux-x64.AppImage";
    hash = "sha256-YmwY8WQIPy3/YZ9lssekgxaLNpMPX2ey1IMqo35j81Q=";
  };
  appimageContents = appimageTools.extractType2 { inherit version pname src; };
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = appimageTools.wrapType2 { inherit version pname src; };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -r bin $out/bin
    mkdir -p $out/share/follow
    cp -a ${appimageContents}/locales $out/share/follow
    cp -a ${appimageContents}/resources $out/share/follow
    cp -a ${appimageContents}/usr/share/icons $out/share/
    install -Dm 644 ${appimageContents}/Follow.desktop -t $out/share/applications/
    substituteInPlace $out/share/applications/Follow.desktop --replace-fail "Follow" "follow"
    wrapProgram $out/bin/follow \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}} --no-update"
    runHook postInstall
  '';

  passthru = {
    updateScript = lib.getExe (writeShellApplication {
      name = "update-follow";
      runtimeInputs = [
        curl
        yq
        common-updater-scripts
      ];
      text = ''
        set -o errexit
        latestLinux="$(curl -sL https://github.com/${owner}/${repo}/releases/latest/download/latest-linux.yml)"
        version="$(echo "$latestLinux" | yq -r .version)"
        update-source-version follow "$version" --source-key=src.src
      '';
    });
  };

  meta = {
    description = "Next generation information browser";
    homepage = "https://github.com/RSSNext/Follow";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ iosmanthus ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "follow";
  };
}
