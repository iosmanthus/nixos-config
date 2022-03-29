{ pkgs, ... }: {
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

  users.extraGroups.docker.members = [ "iosmanthus" ];

  virtualisation.libvirtd = { enable = true; };

  users.extraGroups.vboxusers.members = [ "iosmanthus" ];
  users.extraGroups.libvirtd.members = [ "iosmanthus" ];
}
