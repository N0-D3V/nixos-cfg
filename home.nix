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
    bluez
    bibata-cursors

    gemini-cli

    (pkgs.writeShellScriptBin "vpn-toggle" ''
      if systemctl is-active --quiet openvpn-airvpn; then
        systemctl stop openvpn-airvpn && notify-send "VPN Disconnected"
      else
        systemctl start openvpn-airvpn
        sleep 1
        if systemctl is-active --quiet openvpn-airvpn; then
          notify-send "VPN Connected"
        else
          notify-send "VPN Failed to Connect"
        fi
      fi
    '')
  ];

  programs.fish.shellAliases = {
    af = "anifetch -r 12 -C ~/Videos/AniFetch/*";
    ssh = "kitten ssh";
  };

  # ----------------------
  # Neovim
  # ----------------------

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

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
      vimtex

      leetcode-nvim
    ];

    initLua = ''
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
      -- LEETCODE 
      --------------------------------------------------
      require("leetcode").setup()

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
    extraConfig = ''
      let g:vimtex_view_method = 'zathura'
      let g:vimtex_compiler_method = 'latexmk'
    '';
  };

  home.sessionVariables = {
    QML2_IMPORT_PATH = "$HOME/.nix-profile/lib/qt-6/qml";
  };

  # ----------------------
  # Hyprland
  # ----------------------
  xdg.configFile."fastfetch/config.jsonc".text = ''
    {
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
      "source": "\"$(fastfetch.sh logo)\"",
      "height": 18
    },
    "display": {
      "separator": " : "
    },
    "modules": [
      {
        "type": "custom",
        "format": "┌──────────────────────────────────────────┐"
      },
      {
        "type": "chassis",
        "key": "  󰇺 Chassis",
        "format": "{1} {2} {3}"
      },
      {
        "type": "os",
        "key": "   OS",
        "format": "{2}",
        "keyColor": "red"
      },
      {
        "type": "kernel",
        "key": "   Kernel",
        "format": "{2}",
        "keyColor": "red"
      },
      {
        "type": "packages",
        "key": "  󰏗 Packages",
        "keyColor": "green"
      },
      {
        "type": "display",
        "key": "  󰍹 Display",
        "format": "{1}x{2} @ {3}Hz [{7}]",
        "keyColor": "green"
      },
      {
        "type": "terminal",
        "key": "   Terminal",
        "keyColor": "yellow"
      },
      {
        "type": "wm",
        "key": "  󱗃 WM",
        "format": "{2}",
        "keyColor": "yellow"
      },
      {
        "type": "custom",
        "format": "└──────────────────────────────────────────┘"
      },
      "break",
      {
        "type": "title",
        "key": "  ",
        "format": "{6} {7} {8}"
      },
      {
        "type": "custom",
        "format": "┌──────────────────────────────────────────┐"
      },
      {
        "type": "cpu",
        "format": "{1} @ {7}",
        "key": "   CPU",
        "keyColor": "blue"
      },
      {
        "type": "gpu",
        "format": "{1} {2}",
        "key": "  󰊴 GPU",
        "keyColor": "blue"
      },
      {
        "type": "gpu",
        "format": "{3}",
        "key": "   GPU Driver",
        "keyColor": "magenta"
      },
      {
        "type": "memory",
        "key": "   Memory ",
        "keyColor": "magenta"
      },
      {
        "type": "disk",
        "key": "  󱦟 OS Age ",
        "folders": "/",
        "keyColor": "red",
        "format": "{days} days"
      },
      {
        "type": "uptime",
        "key": "  󱫐 Uptime ",
        "keyColor": "red"
      },
      {
        "type": "custom",
        "format": "└──────────────────────────────────────────┘"
      },
      {
        "type": "colors",
        "paddingLeft": 2,
        "symbol": "circle"
      },
      "break"
    ]
    }
  '';

  xdg.configFile."kitty-custom.conf".text = lib.mkAfter ''
    background_opacity 0.97
    input_delay 0
    repaint_delay 2
    sync_to_monitor no
    wayland_enable_ime no
  '';

  xdg.configFile."hypr/custom/monitors.conf".text = ''
    monitor=,2560x1600@240,auto,1
    #monitor=HDMI-A-1,1920x1080@60,auto,1
    misc {
      vfr = 0
      vrr = 0
      background_color = rgba(131519ff) # default bg color behind transparent stuff
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

    env = TERMINAL,kitty --listen-on unix:@kitty --config ${config.xdg.configHome}/kitty/kitty.conf -1
    env = KITTY_CONFIG_DIRECTORY,${config.xdg.configHome}/kitty
  '';

  xdg.configFile."hypr/custom/windowrules.conf".text = ''
            # Override II's global no_blur
            windowrule = no_blur off, match:class kitty
            windowrule = no_blur off, match:class org.gnome.Nautilus
            windowrule = no_blur off, match:class spotify
            windowrule = no_blur off, match:title Claude
            windowrule = no_blur off, match:class zen-beta
            windowrule = no_blur off, match:class com.rtosta.zapzap

            windowrule = opacity 0.97 override 0.97 override, match:class kitty
            windowrule = opacity 0.93 override 0.93 override, match:class spotify
            windowrule = opacity 0.93 override 0.93 override, match:class org.gnome.Nautilus
            windowrule = opacity 0.97 override 0.97 override, match:title Claude
            windowrule = opacity 0.97 override 0.97 override, match:class zen-beta
            windowrule = opacity 0.95 override 0.95 override, match:class com.rtosta.zapzap

            # --- Zen Browser auth/extension popups ---

    # Bitwarden extension popup
    windowrule = float on, match:title Extension:.*Bitwarden.*
    windowrule = size 400 600, match:title Extension:.*Bitwarden.*
    windowrule = center on, match:title Extension:.*Bitwarden.*

    # Google account auth (passkey, sign-in, Turkish "Oturum açın", etc.)
    windowrule = float on, match:title .*(passkey|Google Hesapları|Google Accounts|Oturum açın|Sign in).*
    windowrule = size 500 650, match:title .*(passkey|Google Hesapları|Google Accounts|Oturum açın|Sign in).*
    windowrule = center on, match:class zen-beta, match:title .*(passkey|Google Hesapları|Google Accounts|Oturum açın|Sign in).*

  '';

  xdg.configFile."hypr/hyprland.conf".text = lib.mkAfter ''
    decoration {
      blur {
        enabled = true
        size = 11
        passes = 3
        ignore_opacity = true
      }
    }

    source = custom/monitors.conf
    source = custom/windowrules.conf
    source = custom/environment.conf

    input {
      kb_layout = us,tr
      kb_options = grp:win_space_toggle
      touchpad {
        disable_while_typing = false
      }
    }

    bind = Super+Shift, V, exec, vpn-toggle

    exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP PATH XDG_DATA_DIRS
    exec-once = gnome-keyring-daemon --start --components=secrets

    hyprexpo-gesture = 3 ld expo

    plugin {
      hyprexpo {
        columns = 3
        gap_size = 5
        bg_col = rgb(000000)
        workspace_method = first 1
      }
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
