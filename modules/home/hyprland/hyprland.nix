{ inputs, pkgs, ... }:
let
  # nixpkgs renamed the `swww` package to `awww`; its binaries are now
  # `awww` / `awww-daemon`. waypaper's swww backend and the wallpaper
  # scripts still invoke `swww` / `swww-daemon`, so expose awww under the
  # old command names for compatibility.
  swww-compat = pkgs.runCommand "swww-compat" { } ''
    mkdir -p $out/bin
    ln -s ${pkgs.awww}/bin/awww $out/bin/swww
    ln -s ${pkgs.awww}/bin/awww-daemon $out/bin/swww-daemon
  '';
in
{
  home.packages = with pkgs; [
    awww
    swww-compat
    inputs.hypr-contrib.packages.${pkgs.system}.grimblast
    inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
    grim
    slurp
    wl-clip-persist
    cliphist
    wf-recorder
    glib
    wayland
    direnv
    nwg-displays
  ];
  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;

    xwayland = {
      enable = true;
      # hidpi = true;
    };
    # enableNvidiaPatches = false;
    systemd.enable = true;
  };
}
