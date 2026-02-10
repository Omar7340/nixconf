{
  flake.nixosModules.hostTower =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:

    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/d947833f-e7c9-4f56-b48b-a2e272d09465";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/FE1D-4654";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      fileSystems."/mnt/SSD" = {
        device = "/dev/disk/by-uuid/2AF6864AF686166B";
        fsType = "ntfs";
        options = [
          "users"
          "x-gvfs-show"
          "nofail"
        ];
      };

      fileSystems."/mnt/HDD" = {
        device = "/dev/disk/by-uuid/3e977eb5-baa8-4a58-b378-ca28f16b06d3";
        fsType = "ext4";
        options = [
          "users"
          "x-gvfs-show"
          "nofail"
        ];
      };
      swapDevices = [
        { device = "/dev/disk/by-uuid/3f388e5f-f456-4862-931a-2b6eda97c302"; }
      ];

      # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
      # (the default) this is the recommended approach. When using systemd-networkd it's
      # still possible to use this option, but it's recommended to use it in conjunction
      # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
      networking.useDHCP = lib.mkDefault true;
      # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
