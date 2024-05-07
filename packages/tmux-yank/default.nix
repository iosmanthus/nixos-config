{ fetchFromGitHub
, tmuxPlugins
, ...
}:
tmuxPlugins.mkTmuxPlugin {
  pluginName = "tmux-yank";
  version = "unstable-2021-06-20";
  src = fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tmux-yank";
    rev = "acfd36e4fcba99f8310a7dfb432111c242fe7392";
    hash = "sha256-/5HPaoOx2U2d8lZZJo5dKmemu6hKgHJYq23hxkddXpA=";
  };
}
