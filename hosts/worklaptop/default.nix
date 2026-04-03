{ pkgs, lib, config, ... }:
{
  imports = [
    ./hardware-configuration.nix  # Hardware config excluded from git
    ./../../modules/core
  ];

  environment.systemPackages = with pkgs; [
    acpi
    brightnessctl
    cpupower-gui
		kubectl
		kubelogin
    powertop
  ];

  services = {
    power-profiles-daemon.enable = false;  # conflicts with TLP

    tlp = {
      enable = true;
      settings = {
        # CPU — AC: full performance, BAT: max power saving
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        # Disable turbo boost on battery
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_HWP_DYN_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 0;

        # Platform profile
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "low-power";

        # AMD GPU power management
        RADEON_DPM_STATE_ON_AC = "performance";
        RADEON_DPM_STATE_ON_BAT = "battery";
        RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
        RADEON_DPM_PERF_LEVEL_ON_BAT = "low";

        # PCIe Active State Power Management
        PCIE_ASPM_ON_AC = "default";
        PCIE_ASPM_ON_BAT = "powersupersave";

        # Wi-Fi power saving
        WIFI_PWR_ON_AC = 1;   # 1=off
        WIFI_PWR_ON_BAT = 5;  # 5=max power save

        # USB autosuspend
        USB_AUTOSUSPEND = 1;

        # Disk power management
        DISK_APM_LEVEL_ON_AC = "254";
        DISK_APM_LEVEL_ON_BAT = "128";

        # NVMe power saving
        AHCI_RUNTIME_PM_ON_AC = "on";
        AHCI_RUNTIME_PM_ON_BAT = "auto";

        # Runtime Power Management for PCI(e) bus devices
        RUNTIME_PM_ON_AC = "on";
        RUNTIME_PM_ON_BAT = "auto";
      };
    };

    upower = {
      enable = true;
      percentageLow = 20;
      percentageCritical = 5;
      percentageAction = 3;
      criticalPowerAction = "PowerOff";
    };

    thermald.enable = false;  # Intel-only, not needed for AMD
  };

  # Let TLP manage CPU governor dynamically
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  # Enable powertop auto-tuning
  powerManagement.powertop.enable = true;

  # Use latest kernel for best AMD pstate support (overrides zen from bootloader.nix)
  boot = {
    kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
    kernelParams = [ "amd_pstate=active" ];
    kernelModules = [ "acpi_call" ];
    extraModulePackages =
      with config.boot.kernelPackages;
      [
        acpi_call
        cpupower
      ]
      ++ [ pkgs.cpupower-gui ];
  };

  # Auto-switch Hyprland power mode on AC/BAT change
  services.udev.extraRules = ''
    ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="${pkgs.systemd}/bin/systemctl --no-block start hyprland-power-battery.service"
    ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="${pkgs.systemd}/bin/systemctl --no-block start hyprland-power-ac.service"
  '';

  systemd.services.hyprland-power-battery = {
    description = "Switch Hyprland to battery power mode";
    serviceConfig = {
      Type = "oneshot";
      User = "magnusjg";
      ExecStart = "${pkgs.bash}/bin/bash -lc 'power-mode battery'";
      Environment = [
        "XDG_RUNTIME_DIR=/run/user/1000"
        "HYPRLAND_INSTANCE_SIGNATURE=auto"
      ];
    };
  };

  systemd.services.hyprland-power-ac = {
    description = "Switch Hyprland to AC power mode";
    serviceConfig = {
      Type = "oneshot";
      User = "magnusjg";
      ExecStart = "${pkgs.bash}/bin/bash -lc 'power-mode ac'";
      Environment = [
        "XDG_RUNTIME_DIR=/run/user/1000"
        "HYPRLAND_INSTANCE_SIGNATURE=auto"
      ];
    };
  };
}
