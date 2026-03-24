{ ...}:
let
	nixvim = import (builtins.fetchGit { 
			url = "https://github.com/Veirt/weathr.git";
			ref = "nixos-25.05";
		});
in
{
  programs.weathr = {
    enable = true;
	};
}

