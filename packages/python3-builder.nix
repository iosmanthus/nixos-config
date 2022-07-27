{ pkgs }:
({ libraries }:
  text:
  pkgs.writers.writePython3
    "python3_builder"
    {
      inherit libraries;
      flakeIgnore = [ "F403" "F401" "W391" "E111" "E302" "E305" ];
    }
    ''
      import os
      src = os.getenv('src')
      srcs = os.getenv('srcs').split()
      out = os.getenv('out')

      def exec(cmd):
        return os.system(cmd)

      ${text}
    '')
