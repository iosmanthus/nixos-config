{
  cairo,
  dpkg,
  fetchurl,
  gdk-pixbuf,
  glib,
  gst_all_1,
  gtk3,
  lib,
  libayatana-appindicator,
  libsoup_3,
  makeDesktopItem,
  makeShellWrapper,
  pango,
  stdenv,
  webkitgtk_4_1,
  xdotool,
  xorg,
}:
stdenv.mkDerivation rec {
  pname = "openai-translator";
  version = "0.4.32";

  src = fetchurl {
    url = "https://github.com/openai-translator/openai-translator/releases/download/v${version}/OpenAI.Translator_${version}_amd64.deb";
    sha256 = "sha256-RjysU72MFeRbIrJh8s8egVLWcSGxGlTNOBd+4wB0XeU=";
  };

  buildInputs = with gst_all_1; [
    gst-libav
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gst-vaapi
    gstreamer
  ];

  nativeBuildInputs = [
    dpkg
    makeShellWrapper
  ];

  desktopItem = makeDesktopItem {
    name = "OpenAI Translator";
    desktopName = "OpenAI Translator";
    exec = "openai-translator";
    icon = "openai-translator";
    comment = "extension and cross-platform desktop application for translation based on ChatGPT API.";
    categories = [ "Education" ];
  };

  LD_LIBRARY_PATH = lib.makeLibraryPath [
    cairo
    gdk-pixbuf
    glib
    gtk3
    libayatana-appindicator
    libsoup_3
    pango
    webkitgtk_4_1
    xdotool
    xorg.libxcb
  ];

  unpackPhase = ''
    dpkg -x $src .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    cp usr/bin/app $out/bin/openai-translator
    cp -r usr/share/icons $out/share/icons

    for icon in $(find $out/share/icons -name '*.png'); do
      mv $icon $(dirname $icon)/openai-translator.png
    done

    install -Dm444 -t $out/share/applications ${desktopItem}/share/applications/*.desktop

    wrapProgram $out/bin/openai-translator \
      --prefix WEBKIT_DISABLE_DMABUF_RENDERER : "true" \
      --prefix LD_LIBRARY_PATH : "${LD_LIBRARY_PATH}" \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"

    mkdir -p $out $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Extension and cross-platform desktop application for translation based on ChatGPT API";
    homepage = "https://github.com/openai-translator/openai-translator";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ iosmanthus ];
    platforms = [ "x86_64-linux" ];
  };
}
