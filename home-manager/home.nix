{
  config,
  pkgs,
  ...
}: {
  home.username = "mtuckerb";
  home.homeDirectory = "/home/mtuckerb";
  home.stateVersion = "23.11";
  home.packages = [
    pkgs.neovim
    pkgs.git
    pkgs.rcm
    pkgs.terminator
    pkgs.nerdfonts
    pkgs._1password-gui
    pkgs._1password
    pkgs.alejandra
    pkgs.thefuck
    pkgs.wakatime
    pkgs.asdf-vm
    pkgs.fzf 
    pkgs.kitty
    pkgs.alacritty
    pkgs.unzip
    pkgs.rtx
    pkgs.cargo
    pkgs.rustc
    pkgs.rust-analyzer
    pkgs.python3
    pkgs.poetry
    pkgs.python311Packages.pip
    pkgs.ruby
    pkgs.neovide
    pkgs.zathura
    pkgs.mpv
    pkgs.sxiv
    pkgs.fluent-gtk-theme
    pkgs.gruvbox-gtk-theme
    pkgs.gruvterial-theme
    pkgs.spacx-gtk-theme
    pkgs.bibata-cursors
    pkgs.bibata-cursors-translucent
    pkgs.firefox
    pkgs.jq
    pkgs.neovim
    pkgs.openssh
    pkgs.ripgrep
    pkgs.fzf
    pkgs.oh-my-posh
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mtuckerb/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    NIXPKGS_ALLOW_UNFREE=1;
  };
  gtk = {
    enable = true;
    theme.name = "adw-gtk3";
    cursorTheme.name = "Bibata-Modern-Ice";
    iconTheme.name = "GruvboxPlus";
  };
  xdg.mimeApps.defaultApplications = {
    "text/plain" = ["neovide.desktop"];
    "application/pdf" = [ "zathura.desktop"];
    "image/*" = ["sxiv.desktop"];
    "video/*" = ["mpv.desktop"];

  };

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName  = "Tucker Bradford";
      userEmail = "tucker@tuckerbradford.com";
      aliases = {
        pu = "push";
        co = "checkout";
        cm = "commit";
      };
    };

    # zsh = {
    #   enable = true;
    #   enableAutosuggestions = true;
    #   enableCompletion = true;
    #   envExtra = ''
    #
    #   '';
    # };
    nushell = {
      enable = true;
      configFile.source = ./config.nu;
      # extraConfig = ./config.nu;
       # shellAliases = {
       # vi = "nvim";
       # };
       # 
   };  
   carapace.enable = true;
   carapace.enableNushellIntegration = true;

   starship = { enable = true;
       settings = {
         add_newline = true;
         character = { 
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
       };
      };
    };
  };
}
