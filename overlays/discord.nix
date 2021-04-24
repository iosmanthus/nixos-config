self: super:
{
  discord = super.discord.overrideAttrs (
    old: {
      src = builtins.fetchTarball {
        url = "https://discord.com/api/download?platform=linux&format=tar.gz";
        sha256 = "sha256:0hcryk53mv9ci94y5y8h7hvc4qr7k5mxj9wjxbbpl7j6spz2rkki";
      };
    }
  );
}
