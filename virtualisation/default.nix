{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    docker-compose
    virt-manager
    virt-viewer
  ];
  virtualisation.docker = {
    enable = true;
    extraOptions = ''
      --default-ulimit nofile=1048576:1048576 --bip "172.17.0.1/24"
    '';
  };

  users.extraGroups.docker.members = [ "${config.machine.userName}" ];

  virtualisation.libvirtd = { enable = true; };

  users.extraGroups.libvirtd.members = [ "${config.machine.userName}" ];
}
