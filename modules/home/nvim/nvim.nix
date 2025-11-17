{ pkgs, ... }:
{
  imports = [
    ./telescope.nix
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;

  };
}
