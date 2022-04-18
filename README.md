iosmanthus 💓 NixOS
==========

My current and **always evolving** NixOS configuration files, always ready for [`@MuggleLego`](https://github.com/MuggleLego).

## Usage

1. Define your machine module

`machines/common` defines a module that can define some machine-specific configuration.

For example, you can define your machine configuration via the module above like:

```nix
machine = {
    userName = "iosmanthus";
    userEmail = "myosmanthustree@gmail.com";
    shell = pkgs.zsh;
    # ...
}
```

2. import machine configuration in `flake.nix`
3. move this repository into your home
4. rebuild

```bash
# For the first rebuild
sudo nixos-rebuild switch --flake#hostname

# For the rest rebuild
sudo nixos-rebuild switch
```