{
  flake.nixosModules.ia = {pkgs, ...}: {
    services.ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      home = "/mnt/SSD/logiciels/ollama";
      loadModels = ["qwen3:8b" "qwen2.5-coder:7b" "deepseek-r1:8b"];
      syncModels = true;
    };
    services.open-webui.enable = true;
  };
}
