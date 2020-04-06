{ config, pkgs, ... }:

{
  programs.home-manager = {
    enable = true;
  };

  home.packages = with pkgs; [

    # Utils
    bat             # better cat
    htop            # better top
    unzip
    gnupg           # GNU programs: gpg, gpg-agent, etc
    tree
    fzf             # Fuzzy Search
    jq              # JSON
    binutils
    file
    exa             # better ls
    fd              # better find
    pax-utils       # Static analysis of files: dumpelf, lddtree, etc.
    xorg.xev        # keyboard codes
    xclip
    clipmenu
    translate-shell # trans -s es -t en   word | multiple words | "this is a sentence."
    curl
    wget
    openvpn
    direnv

    # OS Miscelaneous
    libreoffice
    xscreensaver
    dzen2 # Display messages on screen
    mkpasswd
    input-utils # lsinput: keyboard input
    arandr # Graphical xrandr
    pavucontrol # Configure bluetooth device
    ddcutil # Query and change Linux monitor settings using DDC/CI and USB

    # Apps
    dropbox
    enpass
    thunderbird

    # Wi-fi
    wpa_supplicant
    wpa_supplicant_gui

    # Time tracker
    hamster-time-tracker # nb. hamster required a fix that is present on common.nix.

    # BitTorrent
    transgui

    # Printers
    system-config-printer # GUI

    # Browsers
    chromium

    # Terminals
    konsole
    alacritty # GPU-based

    # Image Processing
    gimp
    scrot  # Screenshots
    nomacs # jpg,png viewer
    gv     # postscript/ghostscript viewer

    # Video Player
    vlc

    # Readers
    zathura # EPUB, PDF and XPS
    typora  # Markdown

    # Disk utility
    udisks
    parted
    ncdu # Disk space usage analyzer
    udiskie # Automounter for removable media

    # Docs
    zeal # note: works offline

    # Chats
    slack
    zoom-us
    skypeforlinux
    hexchat
    rtv # Reddit terminal viewer: https://github.com/michael-lazar/rtv
    (discord.override { nss = pkgs.nss_3_49_2;}) # Fix to open links on browser.

    # OS required tools
    dmenu
    stalonetray

    # Databases
    postgresql # psql included
    pgcli

    # AWS
    awscli

    # DNS
    bind # $ dig www.example.com +nostats +nocomments +nocmd

    # Jekyll
    jekyll
    bundler

    # Docker
    docker-compose lazydocker

    # LaTeX
    texlive.combined.scheme-full # contains every TeX Live package.
    pythonPackages.pygments # required by package minted (code highlight)

    # Nix related
    nix-prefetch-git
    cachix # Cache for nix
    nixops
    nix-index # nix-index, nix-locate
    nix-deploy # Lightweight nixOps, better nix-copy-closure.
    steam-run # Run executable without a nix-derivation.
    patchelf # $ patchelf --print-needed binary_name # Prints required libraries for the dynamic binary.
             # Alternative: ldd, lddtree

    # Python
    python2nix # python -mpython2nix pandas

    ( python37.withPackages(
        pkgs: with pkgs; [ numpy ]
      )
    )

    # RStudio
    # On the shell: nix-shell --packages 'rWrapper.override{ packages = with rPackages; [ ggplot2 ]; }'
    ( rstudioWrapper.override {
      packages = with rPackages;
        [ ggplot2 dplyr xts aplpack readxl openxlsx
          prob Rcmdr RcmdrPlugin_IPSUR rmarkdown tinytex
          rprojroot RcmdrMisc lmtest FactoMineR car
          psych sem rgl multcomp HSAUR
        ];
      }
    )

    # Node.js
    nodejs yarn
    nodePackages.node2nix # https://github.com/svanderburg/node2nix#installation

    # Agda
    haskellPackages.Agda AgdaStdlib

    # C
    gnumake gcc
    gecode # c++ library for constraint satisfiability problems.

    # Haskell
    ghc cabal-install
    stack # Note: non-haskell dependencies at .stack/config.yaml
    cabal2nix

    # Haskell runtime dependencies
    gsl

    # Haskell executables
    haskellPackages.fast-tags
    haskellPackages.ghcid
    haskellPackages.xmobar
    haskellPackages.hoogle
    haskellPackages.pandoc
    haskellPackages.hlint
    haskellPackages.stylish-haskell
    haskellPackages.hindent
    haskellPackages.brittany
    haskellPackages.idris

    # Grammars
    haskellPackages.BNFC # bnfc -m Calc.cf
    haskellPackages.alex # runtime dependecy from bnfc
    haskellPackages.happy  # runtime dependecy from bnfc

    # Profiling in haskell
    (haskell.lib.doJailbreak haskellPackages.threadscope)
    (haskell.lib.doJailbreak haskellPackages.eventlog2html)
    (haskell.lib.doJailbreak haskellPackages.eventlog2html)
    haskellPackages.profiteur
    haskellPackages.prof-flamegraph flameGraph
  ];

  # Monitors
  # TODO `autorandr -c`
  programs.autorandr = {
    enable = true;
    profiles = {
      "laptop" = {
        fingerprint = {
          "eDP-1" = "00ffffffffffff0030e4080600000000001c0104a51f117802e085a3544e9b260e5054000000010101010101010101010101010101012e3680a070381f403020350035ae1000001a542b80a070381f403020350035ae1000001a000000fe004c4720446973706c61790a2020000000fe004c503134305746392d5350463100d5";
        };
        config = {
          "eDP-1" = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
          };
        };
      };

      "home-monitor" = {
        fingerprint = {
          "HDMI-1" = "00ffffffffffff000469a52401010101201a010380351e78ea9de5a654549f260d5054b7ef00714f8180814081c081009500b3000101023a801871382d40582c4500132b2100001e000000fd00324c1e5311000a202020202020000000fc0056473234380a20202020202020000000ff0047384c4d51533030303233300a01dc02031ef14b900504030201111213141f230907078301000065030c0010001a3680a070381e4030203500132b2100001a662156aa51001e30468f3300132b2100001e011d007251d01e206e285500132b2100001e8c0ad08a20e02d10103e9600132b21000018011d8018711c1620582c2500132b2100009e000000000000003a";
        };
        config = {
          "HDMI-1" = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
          };
        };
      };

      #"home-dual" = {
        #fingerprint = {
          #"eDP-1" = "00ffffffffffff0030e4080600000000001c0104a51f117802e085a3544e9b260e5054000000010101010101010101010101010101012e3680a070381f403020350035ae1000001a542b80a070381f403020350035ae1000001a000000fe004c4720446973706c61790a2020000000fe004c503134305746392d5350463100d5";
          #"HDMI-1" = "00ffffffffffff000469a52401010101201a010380351e78ea9de5a654549f260d5054b7ef00714f8180814081c081009500b3000101023a801871382d40582c4500132b2100001e000000fd00324c1e5311000a202020202020000000fc0056473234380a20202020202020000000ff0047384c4d51533030303233300a01dc02031ef14b900504030201111213141f230907078301000065030c0010001a3680a070381e4030203500132b2100001a662156aa51001e30468f3300132b2100001e011d007251d01e206e285500132b2100001e8c0ad08a20e02d10103e9600132b21000018011d8018711c1620582c2500132b2100009e000000000000003a";
        #};
        #config = {
          #"eDP-1" = {
            #enable = true;
            #primary = true;
            #position = "0x0";
            #mode = "1920x1080";
          #};

          #"HDMI-1" = {
            #enable = true;
            #primary = false;
            #position = "1920x0";
            #mode = "1920x1080";
            ##rate = "60.00"; # Setting this will make it fail..
          #};
        #};
      #};
    };
  };

  programs.neovim = {
    enable = true;
    vimAlias =  true;

    # https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/vim.section.md#adding-new-plugins-to-nixpkgs
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
      vimtex
      zeavim-vim
      vim-latex-live-preview # Preview your latex files as pdf.

      # Python setup (syntastic is also used)
      #jedi-vim # LSP Client for Python
      #direnv-vim
      #YouCompleteMe
    ];
    extraConfig = ''
      ${builtins.readFile ./dotfiles/neovim/init.vim}
    '';
  };

  programs.firefox = {
    enable = true;
    enableAdobeFlash = false;
    enableIcedTea = false;
    # nb. it is necessary to manually enable these extensions inside Firefox after the first installation.
    # Source: https://gitlab.com/rycee/nur-expressions/blob/master/pkgs/firefox-addons/addons.json
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      decentraleyes
      refined-github
      cookie-autodelete
      https-everywhere
      reddit-enhancement-suite
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

    initExtra = ''
      eval "$(direnv hook zsh)"
    '';

    shellAliases = {
      ls   = "exa -la --git";
      ".." = "cd ..";
      ":e" = "'vim'";
      ":q" = "'exit'";

      cdHaskell = "cd /home/arnau/haskell";
      cdAgda    = "cd /home/arnau/agda";
      cdNixos   = "cd /etc/nixos";
      cdCoinweb = "cd /home/arnau/haskell/coinweb/on-server";

      gs = "git status -s";
      gco = "git checkout";
      gc = "git commit";
      gac = "git add . && git commit -a -m ";
      branches = "git for-each-ref --sort='-authordate:iso8601' --format=' %(color:green)%(authordate:iso8601)%09%(color:white)%(refname:short)' refs/heads";

      battery = ''upower -i $(upower -e | grep BAT) | grep --color=never -E "state|to\ full|to\ empty|percentage"'';
      mkcd = ''f(){ mkdir -p "$1"; cd "$1" }; f'';

      untar = "tar -xvf";
      untargz = "tar -xzvf";
    };

    "oh-my-zsh" = {
      enable = true;
      theme = "agnoster";
      plugins = [ "git" "sudo" ];
    };
  };

  # Automounter for removable media
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "always";
  };

  services.gpg-agent = {
    enable = true;
    # enableSshSupport = true;
    defaultCacheTtl = 1800;
  };

  systemd.user.services.dropbox = {
    Unit = {
      Description = "Dropbox";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Restart = "on-failure";
      RestartSec = 1;
      ExecStart = "${pkgs.dropbox}/bin/dropbox";
      Environment = "QT_PLUGIN_PATH=/run/current-system/sw/${pkgs.qt5.qtbase.qtPluginPrefix}";
     };

    Install = {
        WantedBy = [ "graphical-session.target" ];
    };
  };

  # Dotfiles
  home.file = {
    ".xmobarrc".source = ./dotfiles/xmonad/.xmobarrc;
    ".stalonetrayrc".source = ./dotfiles/xmonad/.stalonetrayrc;

    ".aws" = {
      source = ./dotfiles/aws;
      recursive = true;
    };

    ".psqlrc".source = ./dotfiles/psql/.psqlrc;

    ".stylish-haskell.yaml".source = ./dotfiles/stylish-haskell/.stylish-haskell.yaml;

    ".config/htop/htoprc".source = ./dotfiles/htop/htoprc;

    ".dmenurc".source = ./dotfiles/dmenu/.dmenurc;

    ".local/share/konsole" = {
      source = ./dotfiles/konsole;
      recursive  = true;
    };

    ".config/alacritty/alacritty.yml".source = ./dotfiles/alacritty/.alacritty.yml;

    ".translate-shell/init.trans".source = ./dotfiles/translate-shell/init.trans;

    ".cabal/config".source = ./dotfiles/cabal/config;
    ".stack/config.yaml".source = ./dotfiles/stack/config.yaml;
    ".ghc/ghci.conf".source = ./dotfiles/ghc/ghci.conf;

    #  nb. .config/git/config overrides .gitconfig
    ".gitconfig".text = ''
      [user]
      email=arnauabella@gmail.com
      name=monadplus
      [pager]
      diff = less
      show = less
      [core]
      editor = nvim
      [color]
      ui = true
    '';

    # nix-env, nix-build, nix-shell
    ".config/nixpkgs/config.nix".text = ''
         { allowUnfree = true;
           allowBroken = true;
         }
    '';

    # Used for python + venv + direnv but didnt work.

    # This has been integrated into direnv stdlib
    ".nix-direnv".source = pkgs.fetchFromGitHub {
       owner = "nix-community";
       repo = "nix-direnv";
       rev = "f9889758694bdfe11251ac475d78a93804dbd93c";
       sha256 = "16mpc6lidmn6annyl4skdixzx7syvwdj9c5la0sidg57l8kh1rqd";
    };
    ".direnvrc".text = ''
      source $HOME/.nix-direnv/direnvrc
    '';

    "haskell/pipes".source = pkgs.fetchFromGitHub {
       owner = "Gabriel439";
       repo = "Haskell-Pipes-Library";
       rev = "7fc14e688771a11fc6fab0f2d60f8b219d661add";
       sha256 = "0xh232xxcc2bw71asg46bpyk119kkvp05d81v7iwwgd0vz9fgqbp";
    };
  };
}
