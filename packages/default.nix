let
  ignoredDirs = [
    "lib"
    "yesplaymusic"
  ];
  branchOverlay =
    { branch
    , system
    , config
    , packages
    , ...
    }:
    let
      pkgs = import branch {
        inherit system config;
      };
    in
    final: prev: builtins.foldl'
      (overlay: package: overlay // {
        ${package} = pkgs.${package};
      })
      { }
      packages;
  packageDirs = with builtins;
    filter (k: k != null)
      (attrValues
        (mapAttrs (k: v: if v == "directory" && !(builtins.any (d: k == d) ignoredDirs) then k else null)
          (readDir ./.)));
  mkPackages = callPackage:
    builtins.foldl'
      (pkgs: pkgDir: pkgs // {
        ${pkgDir} = callPackage (./. + "/${pkgDir}") { };
      })
      { }
      packageDirs;
in
rec {
  inherit branchOverlay;
  packages = pkgs: mkPackages pkgs.callPackage;
  overlay = final: prev: (packages prev) // {
    lib = prev.lib // (import ./lib { pkgs = prev; });
  } // {
    # override attributes
    graphite-gtk-theme = prev.graphite-gtk-theme.overrideAttrs (_: {
      version = "unstable-2023-03-31";
      src = prev.fetchFromGitHub {
        owner = "vinceliuice";
        repo = "Graphite-gtk-theme";
        rev = "54b3cf69ceb4ca204d38dda9d19f4f1bdbcf5739";
        sha256 = "1h090lish16l36pabwkfnd469dp0pmlp6j1qy9ww21mg3rfrnmqz";
      };
    });

    fluent-gtk-theme = prev.fluent-gtk-theme.overrideAttrs (_: {
      version = "unstable-2023-12-12";
      src = prev.fetchFromGitHub {
        owner = "vinceliuice";
        repo = "Fluent-gtk-theme";
        rev = "53d44a2cd1869df84b59e92f244cd922a16c4017";
        sha256 = "0addy0nhyjflvrnwwi0df6k44p09x27nsd66g4yla395x5g82zrp";
      };
    });

    colloid-gtk-theme = prev.colloid-gtk-theme.overrideAttrs (_: {
      src = prev.fetchFromGitHub {
        owner = "vinceliuice";
        repo = "Colloid-gtk-theme";
        rev = "6cba9239b8d04e82171899211fb6df2455d6a89d";
        sha256 = "16wzhracfxn7cjzyz8dalrr6rd53wxvh1lcxcc13ssn02v7202z3";
      };
    });

    feishu = prev.feishu.overrideAttrs (_: rec {
      version = "7.11.9";
      packageHash = "ec62a2df";
      src = builtins.fetchurl {
        url = "https://sf3-cn.feishucdn.com/obj/ee-appcenter/${packageHash}/Feishu-linux_x64-${version}.deb";
        sha256 = "1c4ggcq10knb1gac6rmlb5mdxlz1xrz6i735mfqinvr7qfrqzi4q";
      };
    });

    vistafonts-chs = prev.vistafonts-chs.overrideAttrs (_: {
      src = builtins.fetchurl {
        url = "https://github.com/iosmanthus/nowhere/releases/download/v0.1.0/VistaFont_CHS.EXE";
        sha256 = "1qwm30b8aq9piyqv07hv8b5bac9ms40rsdf8pwix5dyk8020i8xi";
      };
    });

    caddy = prev.callPackage "${prev.path}/pkgs/servers/caddy" {
      buildGoModule = args: prev.buildGoModule (args // {
        version = "unstable-2023-12-15";
        src = prev.fetchFromGitHub {
          owner = "iosmanthus";
          repo = "caddy";
          rev = "18594d72a6636cb68e0c75450c10f44fd38af1f7";
          hash = "sha256-+z9v/CKEgEoDJWGH14VPNBD9q2/dHkvwPHdoOalrWqA=";
        };
        vendorHash = "sha256-sc1WsiSde7GKB+SSEHwQcGn08oq8MbtjlhBPV4VU5eg=";
      });
    };
  };
}
