{ pkgs, ... }:
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
    vlc
    sioyek
    anki
    zotero

    ## Office
    libreoffice
    gnome-calculator

    ## Utility
    dconf-editor
    gnome-disk-utility
    strawberry
    spotify

    ## Communication
    telegram-desktop
    mission-center # GUI resources monitor
    zenity
    signal-desktop
    slack


    ## Level editor
    ldtk
    tiled
  ];
}
