{ config, pkgs, ... }:

{
  programs.home-manager = {
    enable = true;
  };

  # Allow graphical services
  # xsession.enable = true;

  home.packages = with pkgs; [
    bat htop unzip gnupg tree
    vlc # TODO
    shutter # Screenshots
    zathura # EPUB, PDF and XPS
    udisks parted
    curl wget
    mkpasswd
    dmenu # xmonad Alt+p
    xclip
    gnumake gcc
    ghc cabal-install stack
    ncdu # Disk space usage analyzer
    slack discord
    whois
    nix-prefetch-git
    jq
    thunderbird
    dropbox
    enpass # TODO

    haskellPackages.fast-tags
    haskellPackages.ghcid
    haskellPackages.xmobar
    haskellPackages.pandoc
    haskellPackages.brittany

    (zoom-us.overrideAttrs (super: {
      postInstall = ''
        ${super.postInstall}
        wrapProgram $out/bin/zoom-us --set LIBGL_ALWAYS_SOFTWARE 1
      '';
    }))
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias =  true;
    plugins = with pkgs.vimPlugins; [ 
      vim # dracula/vim
      solarized
    ];
    extraConfig = ''
      syntax on
      colorscheme solarized
    '';
     # ${builtins.readFile ./dotfiles/neovim/init.vim}
  };

  programs.firefox = {
    enable = true;
    # TODO check why it fails
    # enableAdobeFlash = true;
    enableIcedTea = true;
  };

  programs.git = {
    enable = true;
    userName = "monadplus";
    userEmail = "arnauabella@gmail.com";
  };

  programs.zsh = {
    enable = true;

    # https://github.com/Powerlevel9k/powerlevel9k/wiki/Install-Instructions#nixos
    # promptInit = "source ${pkgs.zsh-powerlevel9k}/share/zsh-powerlevel9k/powerlevel9k.zsh-theme";

    initExtra = ''
      export TERM="xterm-256color"
    '';

    localVariables = {
      COMPLETITION_WAITING_DOTS = "true";
      
    }; 

    shellAliases = {
      ls = "ls -GFhla";
      ".." = "cd ..";
    };

    "oh-my-zsh" = {
      enable = true;
      theme = "agnoster"; # TODO dracula
      plugins = [ "git" "sudo" ];
    };
  };
}
