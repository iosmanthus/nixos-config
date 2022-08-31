{ stdenv
, fetchurl
, fetchFromGitHub
, pkgs
}:
let
  self = pkgs.clash-data;

  pname = "clash-data";

  version = "unstable-2022-07-27";

  rules = fetchFromGitHub {
    owner = "Loyalsoldier";
    repo = "clash-rules";
    rev = "b7ae77b69e00104ac713d91f7309e53d07805e4c";
    sha256 = "0zfq2ffdfja8d541m9s07b1l41cbzbwvy06ilggr6j8whndw51nf";
  };

  mmdb = fetchurl {
    url = "https://github.com/Dreamacro/maxmind-geoip/releases/download/20220512/Country.mmdb";
    sha256 = "1vhygp5pvkx4jq0m69v9xcxxic52ih98rlz5hq0s4fzqp12pnis0";
  };

  srcs = [ rules mmdb ];
in
stdenv.mkDerivation {
  inherit pname version srcs;

  dontUnpack = true;

  passthru = {
    rulesPath = "${self}/rules";
    mmdbPath = "${self}/Country.mmdb";
  };

  installPhase = pkgs.python3Builder
    {
      libraries = [ ];
    } ''
    exec(f'mkdir -p {out}/rules')
    exec(f'cp {srcs[0]}/* {out}/rules/')
    exec(f'cp {srcs[1]} {out}/Country.mmdb')
  '';
}
