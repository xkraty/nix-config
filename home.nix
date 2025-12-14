{ config, pkgs, lib, ... }:

let
  onePassPath = "~/.1password/agent.sock";
  myGpgKeyId = "D8B2697C34AB583F";
in
{
  home.username = "xkraty";
  home.homeDirectory = "/home/xkraty";
  home.stateVersion = "25.11"; 

  home.packages = with pkgs; [
    git
    lazygit
    docker
    gnupg
    pinentry-qt
    btop
    mise
  ];
  
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {};
  };
  xdg.configFile."hypr/hyprland.conf".source = ./dotfiles/hypr/hyprland.conf;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 300;
    pinentry.package = pkgs.pinentry-qt;
  };

  programs.git = {
    enable = true;
    signing.signByDefault = true;
    signing.key = myGpgKeyId;
    
    settings.user = {
      email = "christian@campoli.me";
      name = "xkraty";
    };
  };

  programs.wofi = {
    enable = true;
  };
  
  programs.zsh = {
   enable = true;

   shellAliases = {
    "nr" = "sudo nixos-rebuild switch --flake ~/nix-config#nixos";
    "nu" = "nix flake update ~/nix-config"; 
    "postgres-start" = "docker compose -f ~/dev/Docker-Postgres --project-name dev-pg up -d";
    "postgres-stop" = "docker compose -f ~/dev/Docker-Postgres --project-name dev-pg stop";
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {};
    extraConfig = ''
      Host *
        IdentityAgent ${onePassPath}
    '';
  };


  programs.waybar = {
    enable = true;
    
    settings = {
      main = lib.importJSON ./dotfiles/waybar/config.json;
    };
    style = builtins.readFile ./dotfiles/waybar/style.css;
  };
}
