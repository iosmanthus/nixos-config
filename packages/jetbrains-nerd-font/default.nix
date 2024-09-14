{ stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "jetbrains-nerd-font";
  version = "unstable-2023-08-17";

  src = fetchFromGitHub {
    owner = "adi1090x";
    repo = "rofi";
    rev = "0c54044bfdf6a8bcf5710b4f8a5fc55c41a536b1";
    sha256 = "1d9f0n66kv940mwgni7rr917gmnkrrfbxsgrpi27swcqiaairc4z";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/truetype/NerdFonts $src/fonts/JetBrains-Mono-Nerd-Font-Complete.ttf

    runHook postInstall
  '';
}
