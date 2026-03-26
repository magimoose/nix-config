{ inputs, ... }:
{
  imports = [ inputs.weathr.homeModules.weathr ];

  programs.weathr = {
    enable = true;
  };
}

