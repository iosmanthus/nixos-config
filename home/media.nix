{ ... }:
{
  services.mpd = {
    enable = true;
    network = {
      startWhenNeeded = true;
    };
  };

  services.mpris-proxy.enable = true;
}
