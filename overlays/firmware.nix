{ system, ... }:
(self: super:
with super;
{
  firmwareLinuxNonfree = firmwareLinuxNonfree.overrideAttrs (
    _: rec {
      version = "2020-12-18";
      src = fetchgit {
        url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
        rev = "refs/tags/" + lib.replaceStrings [ "-" ] [ "" ] version;
        sha256 = "sha256-ZQ2gbWq6XEqF5Cz8NsMGccevccDmXOymiavM/t1YZeU=";
      };
      outputHash = "sha256-hgTfrOmKKpVK+qGuaFtFURLCwcG/cCiT4UYx7qCw+9w=";
    }
  );
})
