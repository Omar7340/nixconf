{
  flake.diskoConfigurations.hostBabel = {
    disko.devices = {
      disk = {
        # Configuration du disque système (HDD)
        main = {
          type = "disk";
          device = "/dev/disk/by-id/ata-HGST_HTS725050A7E630_TF1500WH0M89JM";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };
              swap = {
                size = "8G";
                content = {
                  type = "swap";
                  discardPolicy = "both";
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                };
              };
            };
          };
        };
        # Configuration du disque Media (SSD)
        media = {
          type = "disk";
          device = "/dev/disk/by-id/ata-Samsung_Portable_SSD_T5_S4B1NR0N924589H";
          content = {
            type = "gpt";
            partitions = {
              data = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  # Optimisation pour SSD et gros fichiers (médias)
                  mountOptions = [
                    "defaults"
                    "noatime"
                    "nodiscard"
                  ];
                  mountpoint = "/mnt/media";
                };
              };
            };
          };
        };
      };
    };
  };
}
