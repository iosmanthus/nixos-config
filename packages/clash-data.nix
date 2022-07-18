{ stdenv
, fetchurl
, fetchFromGitHub
, pkgs
}:
let
  self = pkgs.clash-data;

  pname = "clash-data";

  version = "unstable-2022-07-17";

  clashRules = stdenv.mkDerivation {
    inherit version;
    pname = "clash-rules";
    src = fetchFromGitHub {
      owner = "Loyalsoldier";
      repo = "clash-rules";
      rev = "b7ae77b69e00104ac713d91f7309e53d07805e4c";
      sha256 = "0zfq2ffdfja8d541m9s07b1l41cbzbwvy06ilggr6j8whndw51nf";
    };
    installPhase = ''
      mkdir -p $out/rules
      cp $src/*.txt $out/rules
    '';
  };

  mmdb = fetchurl {
    url = "https://github.com/Dreamacro/maxmind-geoip/releases/download/20220512/Country.mmdb";
    sha256 = "1vhygp5pvkx4jq0m69v9xcxxic52ih98rlz5hq0s4fzqp12pnis0";
  };

  srcs = [ clashRules mmdb ];
in
stdenv.mkDerivation {
  inherit pname version srcs;

  dontUnpack = true;

  passthru = {
    rulesPath = "${self}/rules";
    mmdbPath = "${self}/Country.mmdb";
  };

  installPhase = ''
    mkdir -p $out
    for src in $srcs; do 
      if [ -d $src ]; then
        cp -r $src/* $out
      else
        cp $src $out/$(stripHash $src)
      fi
    done
  '';
}
