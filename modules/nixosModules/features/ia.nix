{
  flake.nixosModules.ia = {pkgs, ...}: {
    services.ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      home = "/mnt/SSD/logiciels/ollama";
      loadModels = ["qwen3.5:9b" "llama3.1:8b"];
      syncModels = true;
    };
    services.open-webui.enable = true;

        environment.systemPackages = with pkgs; [
            opencode
        ];
  };
}
