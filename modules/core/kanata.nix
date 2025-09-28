{ config, pkgs, ... }:

{
  # 1. Use the dedicated NixOS option for uinput.
  #    This automatically loads the kernel module, creates the 'uinput' group,
  #    and sets the correct device permissions. It replaces our manual udev rule.
  hardware.uinput.enable = true;

  # 2. Enable and configure the kanata service.
  services.kanata = {
    enable = true;
    # The kanata service automatically creates its own user. We just need to
    # ensure that user is added to the 'uinput' group managed by the option above.
    user = "kanata";
    group = "kanata";

    keyboards = {
      default = {
        # IMPORTANT: Make sure this path is correct for your laptop!
        devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];

        config = ''
          (defsrc
            caps
          )

          (deflayer default
            ;; On tap, send escape. On hold, act as left shift.
            (tap-hold 200 200 esc lsft)
          )
        '';
      };
    };
  };

  # 3. Add the service's user ('kanata') to the 'uinput' group.
  users.groups.uinput.members = [ "kanata" ];
}
