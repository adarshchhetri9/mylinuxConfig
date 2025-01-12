# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs,  ... }:

let
	vimConfig = import ./nvf-configuration.nix { inherit pkgs; };
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.art = {
    isNormalUser = true;
    description = "Art";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "art";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
	menulibre
	kitty 
	fish 
	neofetch 
	hyprlock 
	rofi-wayland-unwrapped  
	brave 
	nemo-with-extensions
	#ntfs3g 
	stow
	git
	xdg-desktop-portal-hyprland
	starship
	hyprshot
	telegram-desktop
	hyprpanel
	ags
	upower
	inputs.zen-browser.packages.x86_64-linux.default #zenBrowser
	btop
	cmatrix
	vscode

	#For discord
	(discord.override {
      	#withOpenASAR = true; # can do this here too
     	withVencord = true;
    	})
]; 

# Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

	# Enabling lightdm
	services.xserver.enable = true;
	services.displayManager.autoLogin.enable = true; #autoLogin
	services.displayManager.autoLogin.user = "art";

	# Enabling Hyprland
	programs.hyprland.enable = true;

	# Enabling fish as my default shell
	programs.fish.enable = true;
	users.defaultUserShell = pkgs.fish;

	# Enabling Fonts & Icons
	fonts.packages = with pkgs; [
	  nerd-fonts.fira-code
	  nerd-fonts.droid-sans-mono
	];

	# Enabling Flakes for experimental programs
	nix.settings.experimental-features = ["nix-command" "flakes"]; 
	
	# Enabling partition Disks in for both Linux and Windows
	fileSystems."/mnt/nvme0n1p5" = {
	  device = "/dev/nvme0n1p5";
	  fsType = "ntfs-3g";
	};

	# Brightness key mapping
	programs.light.enable = true;
  	services.actkbd = {
    	enable = true;
    	bindings = [
      	{ keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 5"; }
      	{ keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 5"; }
    			];
  		};

	# Dependency for battery
 	services.upower.enable = true;
	
	# Neovim in Nix (NVF)
	 programs.nvf = vimConfig.programs.nvf;
	#	enable = true;
	#	settings = {
	#		vim = {
	#			theme = {
	#			enable = true; 
	#			name = "gruvbox";
	#			style = "dark";
	#				};
	#		languages.nix.enable = true;
	#		statusline.lualine.enable = true;
	#		telescope.enable = true;
	#		autocomplete.nvim-cmp.enable = true;
	#			};};
	#		};

 
}