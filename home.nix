{ config, pkgs, ... }:

let
  onePassPath = "~/.1password/agent.sock";
  myGpgKeyId = "D8B2697C34AB583F";
in
{
  home.stateVersion = "25.11"; 

  home.packages = with pkgs; [
    git
    gnupg
    pinentry-qt
  ];
  
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {};
  };
  xdg.configFile."hypr/hyprland.conf".source = ./dotfiles/hypr/hyprland.conf;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    
    pinentry.package = pkgs.pinentry-qt;
    
    maxCacheTtl = 300;
    defaultCacheTtl = 300;
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
}
