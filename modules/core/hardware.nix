{ inputs, pkgs, ... }:
let
  hyprland-pkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system};
in
{
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true; # Required for Steam
      package = hyprland-pkgs.mesa;
      # Mesa includes RADV (AMD Vulkan driver) by default
      # No extra packages needed for basic AMD support
    };
  };
  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = true;
}
