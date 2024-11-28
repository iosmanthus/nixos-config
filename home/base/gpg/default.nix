{ ... }:
{
  imports = [
    ../../base/gpg
  ];

  programs.gpg = {
    enable = true;
    mutableKeys = true;
    mutableTrust = false;
    publicKeys = [
      {
        source = ./0xDEE5BAABFE092169.gpg;
        trust = "ultimate";
      }
      {
        source = ./0xC16B34E00DCD8AE9.gpg;
        trust = "ultimate";
      }
    ];
  };
}
