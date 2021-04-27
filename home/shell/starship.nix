{ config
, pkgs
, ...
}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      time = {
        disabled = false;
        format = "🕙[ $time ](red)";
      };
      username = {
        disabled = false;
        style_user = "blue bold";
        style_root = "green bold";
        format = "[🎃 $user]($style) ";
        show_always = true;
      };
      battery = {
        full_symbol = "🔋";
        charging_symbol = "⚡️";
        discharging_symbol = "💀";
        display = [
          {
            threshold = 10;
            style = "bold red";
          }
          {
            threshold = 80;
            style = "bold yellow";
          }
        ];
      };
      memory_usage = {
        disabled = false;
        format = "[using ](green)$symbol[\${ram}](bold blue)[ = \${ram_pct} ](bold cyan)";
        threshold = -1;
      };
      cmd_duration = {
        min_time = 500;
        format = "[⇡underwent](red) [$duration](bold yellow)";
      };
      hostname = {
        ssh_only = false;
        style = "bold yellow";
      };
      gcloud = {
        disabled = true;
      };
      aws = {
        disabled = true;
      };
    };
  };
}
