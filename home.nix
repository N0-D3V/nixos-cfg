{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.username = "nodev";
  home.homeDirectory = "/home/nodev";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
  programs.illogical-impulse = {
    enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    kdePackages.qt5compat
    kdePackages.qtdeclarative
    papirus-icon-theme
    adwaita-icon-theme
    noto-fonts-cjk-sans
    #bluez
    bibata-cursors
  ];

  # ----------------------
  # Neovim
  # ----------------------
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      lualine-nvim
      nvim-web-devicons
      telescope-nvim
      plenary-nvim
      gitsigns-nvim
      mini-pairs
      nvim-colorizer-lua
    ];

    extraLuaConfig = ''
      --------------------------------------------------
      -- BASIC SETTINGS
      --------------------------------------------------
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.cursorline = true
      vim.opt.termguicolors = true
      vim.opt.signcolumn = "yes"
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.smartindent = true
      vim.opt.scrolloff = 8
      vim.g.mapleader = " "

      --------------------------------------------------
      -- THEME
      --------------------------------------------------
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
      })
      vim.cmd.colorscheme("catppuccin")

      --------------------------------------------------
      -- LUALINE
      --------------------------------------------------
      require("lualine").setup({
        options = {
          theme = "catppuccin",
          section_separators = "",
          component_separators = "",
        }
      })

      --------------------------------------------------
      -- GITSIGNS
      --------------------------------------------------
      require("gitsigns").setup()

      --------------------------------------------------
      -- MINI PAIRS
      --------------------------------------------------
      require("mini.pairs").setup()

      --------------------------------------------------
      -- TELESCOPE
      --------------------------------------------------
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files)
      vim.keymap.set("n", "<leader>fg", builtin.live_grep)
      vim.keymap.set("n", "<leader>fb", builtin.buffers)

      --------------------------------------------------
      -- KEYMAPS
      --------------------------------------------------
      vim.keymap.set("n", "<leader>w", ":w<CR>")
      vim.keymap.set("n", "<leader>q", ":q<CR>")
      vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")

      -- Colorizer config
      require("colorizer").setup({
        "*"; -- tüm dosya tiplerinde çalışsın
      }, {
        RGB      = true,
        RRGGBB   = true,
        names    = false,
        tailwind = false,
        mode     = "background",
      })

    '';
  };

  home.sessionVariables = {
    QML2_IMPORT_PATH = "$HOME/.nix-profile/lib/qt-6/qml";
  };

  # ----------------------
  # Hyprland
  # ----------------------
  xdg.configFile."kitty-custom.conf".text = lib.mkAfter ''
    background_opacity 0.97 
  '';

  xdg.configFile."hypr/custom/monitors.conf".text = ''
    monitor=,2560x1600@144,auto,1.25
    misc {
      vfr = 1
      vrr = 1
    }
    xwayland {
      force_zero_scaling = true
    }

  '';

  xdg.configFile."hypr/custom/environment.conf".text = ''
        env = QSG_RENDER_LOOP,threaded
        env = __NV_PRIME_RENDER_OFFLOAD,0
        env = __GLX_VENDOR_LIBRARY_NAME,nvidia
        env = LIBVA_DRIVER_NAME,nvidia
        env = NVD_BACKEND,direct

        env = HYPRCURSOR_THEME,Bibata-Modern-Ice
    env = HYPRCURSOR_SIZE,24
    env = XCURSOR_THEME,Bibata-Modern-Ice
    env = XCURSOR_SIZE,24

        env = TERMINAL,kitty --listen-on unix:/tmp/kitty --config ${config.xdg.configHome}/kitty/kitty.conf -1
        env = KITTY_CONFIG_DIRECTORY,${config.xdg.configHome}/kitty
  '';

  xdg.configFile."hypr/custom/windowrules.conf".text = ''
    decoration {
      blur {
        enabled = true
        size = 11
        passes = 3
        ignore_opacity = true
      }
    }

    # First override II's global no_blur
    windowrule = no_blur off, match:class kitty
    windowrule = no_blur off, match:class Spotify

    windowrule = opacity 0.97 override 0.97 override, match:class kitty
    windowrule = opacity 0.93 override 0.93 override, match:class Spotify
  '';

  xdg.configFile."hypr/hyprland.conf".text = lib.mkAfter ''
    source = custom/monitors.conf
    source = custom/windowrules.conf
    source = custom/environment.conf

    input {
      kb_layout = us,tr
      kb_options = grp:win_space_toggle
    }
  '';

  gtk.iconTheme.name = "Papirus";

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Classic";
    size = 24;
    package = pkgs.bibata-cursors;
  };

  # Set dconf for GTK apps that don't respect the above
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      cursor-theme = "Bibata-Modern-Classic";
      cursor-size = 24;
    };
  };

  # --------------------------
  # Code
  # --------------------------

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # C# / .NET
        ms-dotnettools.csharp
        ms-dotnettools.csdevkit

        # Python / AI / ML / DL / RL
        ms-python.python
        ms-python.vscode-pylance
        ms-toolsai.jupyter

        # Nix / Linux
        jnoortheen.nix-ide
        mkhl.direnv
        timonwong.shellcheck
        redhat.vscode-yaml

        # Git / Project sanity
        eamodio.gitlens
        mhutchie.git-graph

        # QoL
        usernamehw.errorlens
        christian-kohler.path-intellisense
        editorconfig.editorconfig
      ];

    };
  };
}
