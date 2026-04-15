{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';

    plugins = [
      # Enable a plugin (like autopair or done) if you want
    ];
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
