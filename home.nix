{ config, pkgs, ... }:

let vim-ormolu = pkgs.vimUtils.buildVimPlugin {
    name = "vim-ormolu";
    src = pkgs.fetchFromGitHub {
      owner = "sdiehl";
      repo = "vim-ormolu";
      rev = "0376ced83569994066c61827ad2160449033c509";
      sha256 = "1ga5r24yymqcgjizqyaz6fxl2b8vp66ggzqa63pwl5qdp0rm97b8";
    };
  };

  unstable = import <nixos-unstable> {};
    # TODO seems to be looping..
    #import (builtins.fetchGit {
      #name = "nixpkgs-unstable-2020-09-05";
      #url = "https://github.com/nixos/nixpkgs-channels/";
      ## `git ls-remote https://github.com/nixos/nixpkgs-channels nixos-unstable`
      #ref = "refs/heads/nixpkgs-unstable";
      #rev = "49f820d217f4069472ca8f8f96d1c5681a747f7d";
    #}) {};

in {
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
    brightnessctl

    # Apps
    dropbox
    enpass
    thunderbird
    obs-studio

    # Wi-fi
    wpa_supplicant
    wpa_supplicant_gui

    # Time tracker
    # TODO

    # BitTorrent
    transgui

    # Printers
    system-config-printer # GUI

    # Browsers
    chromium

    # Terminals
    konsole
    alacritty # GPU-based

    # Wine: https://www.winehq.org/
    wine # execute windows binaries

    # Image Processing
    gimp
    scrot  # Screenshots
    nomacs # jpg,png viewer
    gv     # postscript/ghostscript viewer

    # Video Player
    vlc

    # TODO fails to compile (no idea why)
    # Linear Programming
    (cplex.override { releasePath = /home/arnau/MIRI/CPS/lp/cplex/cplex; })

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
    (discord # .override { nss = pkgs.nss_3_52;}
          .overrideAttrs (oldAttrs: { src = builtins.fetchTarball https://discord.com/api/download?platform=linux&format=tar.gz;})
    ) # Fix to open links on browser.

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

    lingeling # Fast SAT solver
    z3        # Fast SMT solver
    (haskell.lib.dontCheck haskellPackages.mios) # Haskell SAT solver

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
    #steam-run # Run executable without a nix-derivation.
    patchelf # $ patchelf --print-needed binary_name # Prints required libraries for the dynamic binary.
             # Alternative: ldd, lddtree
    haskellPackages.niv # https://github.com/nmattia/niv#getting-started

    # Python
    python2nix # python -mpython2nix pandas

    #( python37.withPackages(
        #pkgs: with pkgs; [ numpy ]
      #)
    #)

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

    # Rust
    rustc
    cargo
    rls # language server
    rustfmt
    evcxr # repl

    # Haskell
    ghc cabal-install
    stack # Note: non-haskell dependencies at .stack/config.yaml
    cabal2nix
    llvm_6 # Haskell backend

    # Haskell runtime dependencies
    gsl

    # Haskell executables
    haskellPackages.fast-tags
    haskellPackages.ghcid
    haskellPackages.xmobar
    haskellPackages.hoogle
    haskellPackages.pandoc
    haskellPackages.hlint
    haskellPackages.hindent
    haskellPackages.brittany
    haskellPackages.ormolu

    # Not smooth to be used, not a lot of features
    #unstable.haskellPackages.haskell-language-server

    # Broken: fixed here but still not in nixos-20.03 https://github.com/NixOS/nixpkgs/pull/85656
    (haskellPackages.stylish-haskell.override {
      HsYAML = haskellPackages.HsYAML_0_2_1_0;
      HsYAML-aeson = haskellPackages.HsYAML-aeson.override {
        HsYAML = haskellPackages.HsYAML_0_2_1_0;
      };
    })

    # Grammars
    haskellPackages.BNFC # bnfc -m Calc.cf
    haskellPackages.alex # runtime dependecy from bnfc
    haskellPackages.happy  # runtime dependecy from bnfc

    # Profiling in haskell
    (haskell.lib.doJailbreak haskellPackages.threadscope)
    #(haskell.lib.doJailbreak haskellPackages.eventlog2html)
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
          "HDMI-1" = "00ffffffffffff0009d11e8045540000211c0103803c22782efcd0a6544a9d240e5054a56b80d1c081c081008180a9c0b300010101014dd000a0f0703e8030203500544f2100001a000000ff0042384a3035313033534c300a20000000fd001e4c1ea03c000a202020202020000000fc0042656e51204c43440a2020202001ab02033af253101f0102030405060711121314151620615e5f23090707830100006c030c0020003878200040010267d85dc40178c000e40f0000014dd000a0f0703e8030203500544f2100001e565e00a0a0a0295030203500544f2100001e000000000000000000000000000000000000000000000000000000000000000000cf";
        };
        config = {
          "HDMI-1" = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "3840x2160";
          };
        };
      };
    };
  };

  programs.neovim = {
    enable = true;
    vimAlias =  true;

    # https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/vim.section.md#adding-new-plugins-to-nixpkgs
    plugins = (with pkgs.vimPlugins; [
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
      ghcid
      ultisnips
      vim-snippets
      unicode-vim # https://github.com/chrisbra/unicode.vim

      # Python setup (syntastic is also used)
      jedi-vim # LSP Client for Python
      direnv-vim
      ( YouCompleteMe.overrideAttrs (oldAttrs: {
          installPhase = ''python3 install.py --all''; # This fix is for rust but not working.
        })
      )

      #YouCompleteMe # patched below

      # TODO: rust-vim is not working as expected with cargo mode (rustc seems to be working).
      # Rust
      rust-vim # uses syntastic, tagbar, rustfmt, webapi-vim
      tagbar
      webapi-vim # Playpen integration

      # Agda
      agda-vim

      #coc-nvim

      # Own packages
      vim-ormolu
    ]);

    extraConfig = ''
      ${builtins.readFile ./dotfiles/neovim/init.vim}
    '';
  };

  programs.firefox = {
    enable = true;
    enableAdobeFlash = false;
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

  # Lorri: nix-shell replacement. https://github.com/target/lorri
  services.lorri = {
    enable = true;
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
