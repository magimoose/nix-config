{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    ## Multimedia
    audacity
    gimp
    media-downloader
    obs-studio
    pavucontrol
    soundwireserver
    video-trimmer
		glow
    vlc
    sioyek
    anki
    zotero
		ghidra
		radare2
		(lib.lowPrio (rizin.withPlugins (ps: with ps; [ rz-ghidra ])))
		(cutter.withPlugins (ps: with ps; [ rz-ghidra ]))
		pkg-config
		vim

    ## Office
    libreoffice
    gnome-calculator

    ## Utility
    dconf-editor
    gnome-disk-utility
    strawberry

		vimgolf
		graphviz

    ## Communication
    telegram-desktop
    mission-center # GUI resources monitor
    zenity
    signal-desktop
    slack
		zathura


    ## Level editor
    ldtk
    tiled
  ];
}
