{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ## Lsp
    nixd # nix

    ## formating
    shfmt
    treefmt
    nixfmt

    ## C / C++
    gcc
    gdb
		gtk3
    # gef
    # cmake
    # gnumake
    # valgrind
    # llvmPackages_20.clang-tools

    ## Python
    # python3
    # python312Packages.ipython

		# reverse
		strace
		ltrace

    ## Extra
		k9s
		postgresql
		dbeaver-bin
		zlib
		gnumake
    nodejs
    claude-code
    uv
		qbittorrent
  ];
}
