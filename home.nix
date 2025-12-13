{ config, pkgs, ... }:

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


  programs.waybar = {
    enable = true;
    
    # Optional: Install extra icons for better visuals
    package = pkgs.waybar.override {
      enableModules = [ "custom" "hyprland" ];
    };

    # The actual JSON configuration goes here (modules, position, etc.)
    settings = {
      main = {
        # General position/styling settings
        position = "top";
        height = 30;
        layer = "top";
        
        # Modules to display on the left side
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        
        # Modules to display in the center
        modules-center = [ "clock" ];
        
        # Modules to display on the right side
        modules-right = [ "network" "pulseaudio" "backlight" "battery" "tray" ];
        
        # Module definitions
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = ""; # Terminal icon
            "2" = ""; # Browser icon
            "3" = ""; # Desktop icon
            "urgent" = "";
            "active" = "";
            "default" = "";
          };
        };
        
        clock = {
          format = " {:%H:%M:%S}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        battery = {
          states = {
            good = 90;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = [ "" "" "" "" "" ];
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " {format_source}";
          format-icons = {
            headphone = "headphones";
            handsfree = "phone";
            default = [ "" "" "" ];
          };
        };

        network = {
          format-wifi = " {essid}";
          format-ethernet = "link";
          format-alt = "up {bandwidthUpBytes} down {bandwidthDownBytes}";
        };
        
        # System Tray (for applications like Discord, Telegram, etc.)
        tray = {
          spacing = 10;
        };
        
      };
    };
    
    # We won't add the CSS here, but you can later use:
    # style = builtins.readFile ./dotfiles/waybar/style.css;
  };
}
