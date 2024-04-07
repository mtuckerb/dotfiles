{
  config,
    pkgs,
    ...
}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
  home.username = "mtuckerb";
  home.homeDirectory = "/home/mtuckerb";
  home.stateVersion = "23.11";
  home.shellAliases = {
    vi = "nvim";
    clipboard = "xclip -sel clip";
  };
  home.packages = with pkgs; [
    neovim
      git
      rcm
      terminator
      nerdfonts
      _1password-gui
      _1password
      alejandra
      thefuck
      wakatime
      fzf 
      alacritty
      unzip
      rtx
      cargo
      rustc
      rust-analyzer
      python3
      poetry
      python311Packages.pip
      ruby
      neovide
      zathura
      mpv
      sxiv
      fluent-gtk-theme
      gruvbox-gtk-theme
      gruvterial-theme
      spacx-gtk-theme
      bibata-cursors
      bibata-cursors-translucent
      firefox
      jq
      neovim
      openssh
      ripgrep
      oh-my-posh
      zlib
      guile-zlib
      zlib.dev
      readline
      bzip2
      nix-direnv
      cifs-utils
      fh
      open-vm-tools
      pkg-config
      vscodium
      obsidian
      bat
      armcord
      dbeaver
      xclip
      ironbar
      gtk4-layer-shell 
      ffmpeg
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
# xdg.configFile."starship".source = "${homeDirectory}/.config/home-manager/starship.toml";
  home.sessionVariables = {
    EDITOR = "nvim";
    NIXPKGS_ALLOW_UNFREE = 1;
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
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
        enableNushellIntegration = true;
      nix-direnv.enable = true;
    };
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

    zsh = {
      enable = true;
      enableCompletion = true;
      envExtra = ''

        '';
      initExtra = ''
        bindkey '^A' beginning-of-line
        bindkey '^E' end-of-line
        '';
      autosuggestion.enable = true;
      historySubstringSearch.enable = true;
      syntaxHighlighting.enable = true;

    };
    nushell = {
      enable = true;
      configFile.source = ./config.nu;
# extraConfig = ./config.nu;
# shellAliases = {
# vi = "nvim";
# };
# 
    };  
#    ironbar = {
#      enable = true;
#      config = {
#        anchor_to_edges = true;
#        position = "bottom";
#        icon_theme = "Paper";
#        [[start]]
#          type = "workspaces";
#        all_monitors = false;
#
#        [start.name_map]
#          1 = "󰙯";
#        2 = "icon:firefox";
#        3 = "";
#        Games = "icon:steam";
#        Code = "";
#
#        [[start]]
#          type = "launcher";
#        favorites = [
#          "firefox",
#          "discord",
#          "steam",
#        ];
#        show_names = false;
#        show_icons = true;
#
#        [[start]]
#          type = "label";
#        label = "random num: {{500:echo FIXME}}";
#
#        [[end]]
#          type = "music";
#        player_type = "mpd";
#        music_dir = "/home/mtuckerb/Music";
#
#        [end.truncate]
#          mode = "end";
#        max_length = 100;
#
#        [[end]]
#          type = "music";
#        player_type = "mpd";
#        host = "chloe:6600"
#          truncate = "end";
#
#        [[end]]
#          type = "sys_info";
#        format = [
#          " {cpu_percent}% | {temp_c:k10temp_Tccd1}°C",
#          " {memory_used} / {memory_total} GB ({memory_percent}%)",
#          "| {swap_used} / {swap_total} GB ({swap_percent}%)",
#          "󰋊 {disk_used:/} / {disk_total:/} GB ({disk_percent:/}%)",
#          "󰓢 {net_down:enp39s0} / {net_up:enp39s0} Mbps",
#          "󰖡 {load_average:1} | {load_average:5} | {load_average:15}",
#          "󰥔 {uptime}",
#        ];
#
#        [end.interval]
#          memory = 30;
#        cpu = 1;
#        temps = 5;
#        disks = 300;
#        networks = 3;
#
#        [[end]]
#          type = "volume";
#        format = "{icon} {volume}%";
#        max_volume = 100;
#
#        [end.icons]
#          volume_high = "󰕾";
#        volume_medium = "󰖀";
#        volume_low = "󰕿";
#        muted = "󰝟";
#
#        [[end]]
#          type = "clipboard";
#        max_items = 3;
#
#        [end.truncate]
#          mode = "end";
#        length = 50;
#
#        [[end]]
#          type = "custom";
#        class = "power-menu";
#        tooltip = "Up: {{30000:uptime -p | cut -d ' ' -f2-}}";
#
#        [[end.bar]]
#          type = "button";
#        name = "power-btn";
#        label = "";
#        on_click = "popup:toggle";
#
#        [[end.popup]]
#          type = "box";
#        orientation = "vertical";
#
#        [[end.popup.widgets]]
#          type = "label";
#        name = "header";
#        label = "Power menu";
#
#        [[end.popup.widgets]]
#          type = "box";
#
#        [[end.popup.widgets.widgets]]
#          type = "button";
#        class = "power-btn";
#        label = "<span font-size='40pt'></span>";
#        on_click = "!shutdown now";
#
#        [[end.popup.widgets.widgets]]
#          type = "button";
#        class = "power-btn";
#        label = "<span font-size='40pt'></span>";
#        on_click = "!reboot";
#
#        [[end.popup.widgets]]
#          type = "label";
#        name = "uptime";
#        label = "Uptime: {{30000:uptime -p | cut -d ' ' -f2-}}";
#
#        [[end]]
#          type = "clock";
#
#        [[end]]
#          type = "notifications";
#        show_count = true;
#
#        [end.icons]
#          closed_none = "󰍥";
#        closed_some = "󱥂";
#        closed_dnd = "󱅯";
#        open_none = "󰍡";
#        open_some = "󱥁";
#        open_dnd = "󱅮";
#      };
    #   style = "";
    #   package = inputs.ironbar;
    #   features = ["feature" "another_feature"];
    # };

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
