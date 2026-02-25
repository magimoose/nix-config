{ ... }:
{
  services.fprintd.enable = true;

  security = {
    rtkit.enable = true;
    sudo.enable = true;

    pam.services = {
      swaylock = { };
      hyprlock = {
        fprintAuth = true;
      };
    };
  };
}
