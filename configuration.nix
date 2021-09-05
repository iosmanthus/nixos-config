# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./hardware-extra.nix
      ./desktop
      ./system
      ./network
      ./virtualisation
      ./misc
    ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      dates = "weekly";
      automatic = true;
      persistent = true;
      options = "--delete-older-than 2d";
    };
  };

  environment.etc = {
    "nixos/flake.nix".source = config.users.users.iosmanthus.home + "/projects/nix/nixos-config/flake.nix";
  };
  environment.pathsToLink = [ "/share/zsh" ];

  # nixpkgs configuration
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs;
    [
      lsof
      wget
      vim
      file
      git
      bind
      yesplaymusic
    ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
