{
  admin = import ../base/admin;
  home-manager =
    { ... }:
    {
      imports = [
        ../base/base16
      ];
    };
  sing-box = import ../darwin/sing-box;
}
