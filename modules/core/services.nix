{ pkgs, ... }:
{
  services = {
    gvfs.enable = true;
    blueman.enable = true; # for the Blueman applet (optional)
    gnome = {
      tinysparql.enable = true;
      gnome-keyring.enable = true;
    };

    dbus.enable = true;
    fstrim.enable = true;

    # needed for GNOME services outside of GNOME Desktop
    dbus.packages = with pkgs; [
      gcr
      gnome-settings-daemon
    ];

    logind.settings.Login = {
      # don’t shutdown when power button is short-pressed
      HandlePowerKey = "ignore";
    };
  };
  virtualisation.docker.enable = true;
}
