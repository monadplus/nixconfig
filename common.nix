{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    ref = "master";
    rev = "0f1c9f25cf03cd5ed62db05c461af7e13f84a7b6";
  };
in
{
  imports = [
    "${home-manager}/nixos"
  ];

  nixpkgs.config = {
    allowUnfree = true; # Allow packages with non-free licenses.
    allowBroken = true;
  };

  system.stateVersion = "19.09";

  # https://github.com/rycee/home-manager/issues/463
  home-manager.users.arnau = import ./home.nix { inherit pkgs config; };

  # Enable the OpenSSH daemon (allow secure remote logins)
  services.openssh.enable = true;

  services.printing = {
    enable = true;
    # drivers = (with pkgs; [ gutenprint cups-bjnp hplip cnijfilter2 ]);
  };

  i18n = lib.mkForce {
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Madrid";

  fonts = {
    fontconfig.enable = true;
    enableCoreFonts = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      powerline-fonts
      nerdfonts # vim-devicons
      # Do you need them ?
      material-icons
      material-design-icons
    ];
  };

  users = {
    mutableUsers = false; # Don't allow imperative style
    extraUsers = [
      {
        name = "arnau";
        createHome = true;
        home = "/home/arnau";
	group = "users";
	extraGroups = [ "wheel" "networkmanager" "docker"];
	isNormalUser = true;
	uid = 1000;
	useDefaultShell = false;
	shell = "/run/current-system/sw/bin/zsh";
        hashedPassword = "$6$hKXoaMQzxJ$TI79FW9KtvORSrQKP5cqZR5fzOISMLDyH80BnBlg8G61piAe6qCw.07OVWk.6MfQO1l3mBhdTckNfnBpkQSCh0";
      }
    ];
  };

  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
    BROWSER = "firefox";
  };

  documentation = {
    man.enable = true;
  };

  # TODO merge with home.nix
  programs = {
    command-not-found.enable = true;

    ssh.startAgent = true; # Start OpenSSH agent when you log in (e.g. ssh-add ..)

    zsh.enable = true;
    # https://github.com/Powerlevel9k/powerlevel9k/wiki/Install-Instructions#nixos
    zsh.promptInit = "source ${pkgs.zsh-powerlevel9k}/share/zsh-powerlevel9k/powerlevel9k.zsh-theme";
  };

}
