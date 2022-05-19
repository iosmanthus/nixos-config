{ ... }:
{
  services.mpd = {
    enable = true;
    network = {
      listenAddress = "any";
      startWhenNeeded = true;
    };
  };

  services.mpris-proxy.enable = true;

  services.mpdris2 = {
    enable = true;
    multimediaKeys = true;
    notifications = true;
  };
}
