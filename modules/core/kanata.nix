{ config, pkgs, ... }:

{
  # 1. Use the dedicated NixOS option for uinput.
  #    This automatically loads the kernel module, creates the 'uinput' group,
  #    and sets the correct device permissions.
  hardware.uinput.enable = true;

  # 2. Enable and configure the kanata service.
  #    The service will create its own 'kanata' user automatically.
  services.kanata = {
    enable = true;
    keyboards = {
      default = {
        # IMPORTANT: Make sure this path is correct for your laptop!
        # You can find it with `ls /dev/input/by-path/`
        devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];

        config = ''
          (defsrc
            caps
          )

          (deflayer default
            ;; On tap, send escape. On hold, act as left shift.
            (tap-hold 100 100 esc lsft)
          )
        '';
      };
    };
  };

  # 3. Add the service's user ('kanata') to the 'uinput' group.
  #    This is the crucial step that grants the service the permissions it needs.
  users.groups.uinput.members = [ "kanata" ];
}
