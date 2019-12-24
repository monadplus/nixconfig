{ config, pkgs, ... }:

{
  programs.home-manager = {
    enable = true;
  };

  # Allow graphical services
  # xsession.enable = true;

  home.packages = with pkgs; [
    bat htop unzip gnupg tree fzf mkpasswd jq
    input-utils # lsinput: keyboard input
    xclip # clipmenu copyq parcellite
    wpa_supplicant_gui
    curl wget
    konsole
    vlc # works on plasma
    xscreensaver
    gimp
    shutter scrot # Screenshots
    zathura # EPUB, PDF and XPS
    udisks parted
    dmenu # xmonad Alt+p
    whois
    gnumake gcc
    ghc cabal-install stack nix-prefetch-git
    ncdu # Disk space usage analyzer
    slack discord
    dropbox enpass thunderbird

    haskellPackages.fast-tags
    haskellPackages.ghcid
    haskellPackages.xmobar
    haskellPackages.hoogle
    haskellPackages.pandoc
    haskellPackages.stylish-haskell
    haskellPackages.hindent
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
      vim-nix
      vim-fugitive
      vim-airline
      vim-airline-themes
      fzfWrapper
      nerdtree
      nerdcommenter
      rainbow
      vim-surround
      vim-easy-align
      neomake
      vim-hoogle
      vim-multiple-cursors
      lightline-vim
      nerdtree-git-plugin
      vim-gitgutter
      haskell-vim
      vim-stylishask
      vim-hindent
      vim-unimpaired
      Recover-vim
      supertab
      vim-markdown
      syntastic
      vim # dracula/vim
      solarized
      vim-devicons
    ];
    extraConfig = ''
      ${builtins.readFile ./dotfiles/neovim/init.vim}
    '';
  };

  programs.firefox = {
    enable = true;
    # TODO check why it fails
    # enableAdobeFlash = true;
    enableIcedTea = true;
    # nb. it is necessary to manually enable these extensions inside Firefox after the first installation.
    # Source: https://gitlab.com/rycee/nur-expressions/blob/master/pkgs/firefox-addons/addons.json
    # Notice this is using NUR
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      decentraleyes
      refined-github
      cookie-autodelete
      # TODO
      # enpass
    ];
  };

  programs.git = {
    enable = true;
    userName = "monadplus";
    userEmail = "arnauabella@gmail.com";
  };

  programs.zsh = {
    enable = true;

    localVariables = {
      COMPLETITION_WAITING_DOTS = "true";
    };

    shellAliases = {
      ls = "ls -GFhla";
      ".." = "cd ..";
      # Alternative: `tlp-stat -b`
      battery = ''upower -i $(upower -e | grep BAT) | grep --color=never -E "state|to\ full|to\ empty|percentage"'';
    };

    "oh-my-zsh" = {
      enable = true;
      theme = "agnoster";
      plugins = [ "git" "sudo" ];
    };
  };
}
