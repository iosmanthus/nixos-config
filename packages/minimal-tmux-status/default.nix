{ fetchFromGitHub, tmuxPlugins, ... }:

tmuxPlugins.mkTmuxPlugin {
  pluginName = "minimal-tmux-status";
  version = "unstable-2024-04-25";
  src = fetchFromGitHub {
    owner = "niksingh710";
    repo = "minimal-tmux-status";
    rev = "ee00ccc15a6fdd42b98567602434f7c9131ef89f";
    hash = "sha256-tC9KIuEpMNbBbM6u3HZF0le73aybvA7agNBWYksKBDY=";
  };
  rtpFilePath = "minimal.tmux";
}
