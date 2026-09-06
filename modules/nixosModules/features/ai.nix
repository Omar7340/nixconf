{pkgs, ...}: {
  services = {
    ollama = {
      enable = false;
      package = pkgs.ollama-cuda;
      home = "/mnt/SSD/logiciels/ollama";
      loadModels = ["qwen3.5:9b" "llama3.1:8b"];
      syncModels = true;
    };
    open-webui.enable = false;
  };
  environment.systemPackages = with pkgs; [
    opencode
    codex
    herdr
  ];
}
