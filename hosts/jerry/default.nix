{ 
  username,
  inputs, 
  config,
  lib,
  pkgs,
  ...
}: {
     users.users.${username} = {
    isNormalUser = true;
    description = username;
  };
  nixpkgs.config.cudaSupport = true;
  imports = [
    ../../pkgs/desktop
    ../../pkgs/desktop/awesome
    ../../pkgs/desktop/hyprland
    ./hardware.nix
  ];

  networking = {
    hostName = username;
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };

  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    graphics.enable32Bit = true;
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      timeout = 5;
    };

    kernelParams = [];
  };


  services = {
    asusd = {
      enable = true;
      enableUserService = true;
      asusdConfig.text = ''
        (
          charge_control_end_threshold: 100,
          panel_od: false,
          mini_led_mode: false,
          disable_nvidia_powerd_on_battery: true,
          ac_command: "",
          bat_command: "",
          platform_policy_on_battery: Quiet,
          platform_policy_on_ac: Quiet,
          ppt_pl1_spl: None,
          ppt_pl2_sppt: None,
          ppt_fppt: None,
          ppt_apu_sppt: None,
          ppt_platform_sppt: None,
          nv_dynamic_boost: None,
          nv_temp_target: None,
        )
      '';
      profileConfig.text = ''
        (
          active_profile: Quiet,
        )
      '';
    };
  };

  home-manager.users.${username} = {
    home.username = username;
    home.homeDirectory = "/home/${username}";
    imports = [
      ./home.nix
    ];
  };

  system.stateVersion = "24.11";
}