{
  admin = import ../base/admin;
  home-manager =
    { ... }:
    {
      imports = [
        ../base/base16
      ];
    };
}
