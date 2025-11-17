{ pkgs, ... }:
{
  imports = [
    ./telescope.nix
    ./nvim-cmp.nix
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;

  };
}
