{
  lib,
  ...
}:
{
  imports = [
    ../../base/kitty
  ];

  programs.kitty = {
    font = lib.mkForce {
      name = "monospace";
      size = 15;
    };
  };
}
