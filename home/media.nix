{ ... }:
{
  services.mpd.enable = true;

  services.mpris-proxy.enable = true;

  services.mpdris2 = {
    enable = true;
    multimediaKeys = true;
    notifications = true;
  };
}
