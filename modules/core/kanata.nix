{ config, pkgs, ... }:

{
  # 1. Enable the kernel module required for kanata
  boot.kernelModules = [ "uinput" ];

  # 2. Enable the kanata service
  services.kanata = {
    enable = true;

    # 3. Define a keyboard configuration
    keyboards = {
      # You can name this anything, e.g., "default", "laptop", "mykeyboard"
      default = {
        # 4. Specify the device to apply the remapping to.
        #    Using "*" applies it to all keyboards. For more specific targeting,
        #    you can find your keyboard's event path.
        devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ]; # Example for a laptop keyboard

        # 5. Define the key mapping configuration using kanata's syntax
        config = ''
          (defsrc
            caps
          )

          (deflayer default
            (tap-hold 200 200 caps lsft)
          )
        '';
      };
    };
  };

  # 6. Ensure the necessary user groups exist and have the right permissions
  users.groups.uinput.members = [ "root" "kanata" ];
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput"
  '';
}
