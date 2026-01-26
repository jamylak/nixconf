{
  config,
  pkgs,
  lib,
  nvimconf,
  dotfiles,
  ghostty,
  fzf-fish,
  chomper,
  osConfig ? null,
  ...
}:
let
  # Optional module arg; default to false if not provided.
  isVmware = config._module.args.isVmware or false;
  isNixos = osConfig != null && osConfig.system ? nixos;
  isVmwareHost = isVmware || (isNixos && (osConfig.networking.hostName or "") == "vmware");
  ghosttyPkg = ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.username = lib.mkDefault "dev";
  home.homeDirectory = lib.mkDefault "/home/dev";

  home.stateVersion = "24.05";

  # User session timezone for KDE and other apps.
  home.sessionVariables = {
    TZ = "Australia/Sydney";
    # Clear IM module vars to avoid IBus warnings.
    QT_IM_MODULE = "";
    GTK_IM_MODULE = "";
  };

  programs.home-manager.enable = true;

  # Example: install neovim
  home.packages = [
    pkgs.neovide
    pkgs.neovim
    pkgs.vim
    pkgs.gnumake
    pkgs.cargo
    pkgs.rustc
    pkgs.cmake
    pkgs.ninja
    pkgs.starship
    pkgs.fish
    pkgs.fzf
    pkgs.eza
    pkgs.yazi
    pkgs.btop
    pkgs.lazygit
    pkgs.helix
    pkgs.ripgrep
    pkgs.fd
    pkgs.git
    pkgs.gh
    pkgs.openssh
    pkgs.curl
    pkgs.wget
    pkgs.unzip
    pkgs.zip
    pkgs.uv
    pkgs.xz
    pkgs.gzip
    pkgs.gnutar
    pkgs.nodejs
    pkgs.binutils
    pkgs.lldb
    (pkgs.python3.withPackages (ps: [
      ps.debugpy
    ]))
    pkgs.stdenv.cc
    pkgs.zig
    pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter
    chomper.packages.${pkgs.stdenv.hostPlatform.system}.default

    # LSPs
    pkgs.zls
    pkgs.clang-tools
    pkgs.lua-language-server
    pkgs.asm-lsp
    pkgs.rust-analyzer
    pkgs.fish-lsp
    pkgs.nodePackages.yaml-language-server
    pkgs.nixd
    pkgs.ty
    pkgs.taplo
    # pkgs.nodePackages.vscode-langservers-extracted
    # pkgs.gopls
    # pkgs.lemminx
    # pkgs.nodePackages.typescript-language-server
    # pkgs.nodePackages.typescript
  ]
  ++ lib.optionals isNixos ([
    pkgs.alacritty
    pkgs.kitty
    ghosttyPkg
    pkgs.brave
    pkgs.vlc
    pkgs.qt6.qttools
    pkgs.wl-clipboard
    pkgs.rofi
    pkgs.kdePackages.krohnkite
    (pkgs.writeShellScriptBin "next-desktop" ''
      qdbus org.kde.KWin /KWin org.kde.KWin.nextDesktop
    '')
    (pkgs.writeShellScriptBin "prev-desktop" ''
      qdbus org.kde.KWin /KWin org.kde.KWin.previousDesktop
    '')
    (pkgs.writeShellScriptBin "window-next-desktop" ''
      qdbus org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut "Window to Next Desktop"
    '')
    (pkgs.writeShellScriptBin "window-prev-desktop" ''
      qdbus org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut "Window to Previous Desktop"
    '')
  ])
  ++ lib.optionals (!isNixos) [
  ];

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      dracula
    ];
    extraConfig = ''
      source-file ${dotfiles}/.tmux.minimal.conf
    '';
  };

  programs.git = {
    enable = true;
    settings = lib.mkIf isVmwareHost {
      safe = {
        directory = "*";
      };
    };
  };

  xdg.configFile."nvim".source = nvimconf;
  xdg.configFile."dotfiles".source = dotfiles;

  xdg.configFile."fish/config.fish".source = "${dotfiles}/fish/config.fish";
  xdg.configFile."fish/conf.d".source = "${fzf-fish}/conf.d";
  xdg.configFile."fish/functions".source = "${fzf-fish}/functions";
  xdg.configFile."alacritty".source = "${dotfiles}/alacritty";
  xdg.configFile."kitty".source = "${dotfiles}/kitty";
  xdg.configFile."ghostty".source = "${dotfiles}/ghostty";
  xdg.configFile."helix".source = "${dotfiles}/helix";
  xdg.configFile."yazi".source = "${dotfiles}/yazi";
  xdg.configFile."btop/btop.conf".source = "${dotfiles}/btop/btop.conf";
  xdg.configFile."lazygit".source = "${dotfiles}/lazygit";
  xdg.configFile.".yabairc".source = "${dotfiles}/.yabairc";
  programs.plasma = lib.mkIf isNixos {
    enable = true;
    kwin.virtualDesktops = {
      number = 6;
    };
    # krunner = {
    #   shortcuts.launch = "Meta+Space";
    # };
    shortcuts = {
      "org.kde.krunner.desktop" = {
        "_launch" = [
          "Alt+Space"
          "Meta+Space"
        ];
      };
      "kwin" = {
        "Close Window" = "Meta+Q";
        "Overview" = [ ];
        "Grid View" = "Ctrl+Up";
        "Present Windows" = [ ];
        "Present Windows All" = [ ];
        "Show Desktop" = [ ];
        "Switch Window Up" = [ ];
        "Switch Window Down" = [ ];
        "Switch Window Left" = [ ];
        "Switch Window Right" = [ ];
        "Switch to Next Desktop" = [ "Ctrl+Alt+N" ];
        "Switch to Previous Desktop" = "Ctrl+Alt+P";
        "Window to Next Desktop" = "Meta+Ctrl+N";
        "Window to Previous Desktop" = "Meta+Ctrl+P";
        "Edit Tiles" = [ ];
        "Walk Through Windows" = [ ];
        "Walk Through Windows (Reverse)" = [ ];
        "KrohnkiteBTreeLayout" = [ ];
        "KrohnkiteDecrease" = [ ];
        "KrohnkiteFloatAll" = [ ];
        "KrohnkiteFloatingLayout" = [ ];
        "KrohnkiteFocusDown" = [ ];
        "KrohnkiteFocusLeft" = [ ];
        "KrohnkiteFocusNext" = [ ];
        "KrohnkiteFocusPrev" = [ ];
        "KrohnkiteFocusRight" = [ ];
        "KrohnkiteFocusUp" = [ ];
        "KrohnkiteGrowHeight" = [ ];
        "KrohnkiteIncrease" = [ ];
        "KrohnkiteMonocleLayout" = [ ];
        "KrohnkiteNextLayout" = [ ];
        "KrohnkitePreviousLayout" = [ ];
        "KrohnkiteQuarterLayout" = [ ];
        "KrohnkiteRotate" = [ ];
        "KrohnkiteRotatePart" = [ ];
        "KrohnkiteSetMaster" = [ ];
        "KrohnkiteShiftDown" = [ ];
        "KrohnkiteShiftLeft" = [ ];
        "KrohnkiteShiftRight" = [ ];
        "KrohnkiteShiftUp" = [ ];
        "KrohnkiteShrinkHeight" = [ ];
        "KrohnkiteShrinkWidth" = [ ];
        "KrohnkiteSpiralLayout" = [ ];
        "KrohnkiteSpreadLayout" = [ ];
        "KrohnkiteStackedLayout" = [ ];
        "KrohnkiteStairLayout" = [ ];
        "KrohnkiteTileLayout" = [ ];
        "KrohnkiteToggleFloat" = [ ];
        "KrohnkiteTreeColumnLayout" = [ ];
        "KrohnkitegrowWidth" = [ ];
      };
      plasmashell = {
        "next activity" = [ ];
        "show-on-mouse-pos" = [ ];
      };
    };
    # Workaround: invoke Krohnkite shortcuts via qdbus due to issues with direct bindings.
    hotkeys.commands = {
      krohnkiteNextLayout = {
        name = "Krohnkite: Next Layout";
        key = "Ctrl+Alt+Space";
        command = ''
          gdbus call --session --dest org.kde.kglobalaccel --object-path /component/kwin --method org.kde.kglobalaccel.Component.invokeShortcut "KrohnkiteNextLayout"
        '';
      };
      krohnkiteToggleFloating = {
        name = "Krohnkite: Toggle Floating";
        key = "Ctrl+Alt+T";
        command = ''
          gdbus call --session --dest org.kde.kglobalaccel --object-path /component/kwin --method org.kde.kglobalaccel.Component.invokeShortcut "KrohnkiteToggleFloating"
        '';
      };
      krohnkiteIncrease = {
        name = "Krohnkite: Increase";
        key = "Ctrl+Alt+L";
        command = ''
          gdbus call --session --dest org.kde.kglobalaccel --object-path /component/kwin --method org.kde.kglobalaccel.Component.invokeShortcut "KrohnkitegrowWidth"
        '';
      };
      krohnkiteDecrease = {
        name = "Krohnkite: Decrease";
        key = "Ctrl+Alt+H";
        command = ''
          gdbus call --session --dest org.kde.kglobalaccel --object-path /component/kwin --method org.kde.kglobalaccel.Component.invokeShortcut "KrohnkiteShrinkWidth"
        '';
      };
      krohnkiteFocusNext = {
        name = "Krohnkite: Focus Next";
        key = "Ctrl+Alt+F";
        command = ''
          gdbus call --session --dest org.kde.kglobalaccel --object-path /component/kwin --method org.kde.kglobalaccel.Component.invokeShortcut "KrohnkiteFocusNext"
        '';
      };
      krohnkiteFocusPrev = {
        name = "Krohnkite: Focus Previous";
        key = "Ctrl+Alt+B";
        command = ''
          gdbus call --session --dest org.kde.kglobalaccel --object-path /component/kwin --method org.kde.kglobalaccel.Component.invokeShortcut "KrohnkiteFocusPrev"
        '';
      };
      krohnkiteSetMaster = {
        name = "Krohnkite: Set as Master";
        key = "Ctrl+Alt+Return";
        command = ''
          gdbus call --session --dest org.kde.kglobalaccel --object-path /component/kwin --method org.kde.kglobalaccel.Component.invokeShortcut "KrohnkiteSetMaster"
        '';
      };
    };
    configFile = {
      "kwinrc" = {
        "Plugins" = {
          slideEnabled = false;
          wobblywindowsEnabled = true;
          desktopgrid-cornersEnabled = true;
          krohnkiteEnabled = true;
        };
        "Script-krohnkite" = {
          monocleLayoutOrder = 1;
          columnsLayoutOrder = 2;
          enableColumnsLayout = true;
          tileLayoutOrder = 0;
          threeColumnLayoutOrder = 0;
          spiralLayoutOrder = 0;
          quarterLayoutOrder = 0;
          stackedLayoutOrder = 0;
          spreadLayoutOrder = 0;
          floatingLayoutOrder = 0;
          stairLayoutOrder = 0;
          binaryTreeLayoutOrder = 0;
          cascadeLayoutOrder = 0;
        };
        "ModifierOnlyShortcuts" = {
          Meta = "org.kde.krunner.desktop,_launch,Meta";
        };
        "Effect-DesktopGrid" = {
          BorderActivate = 9;
        };
        "ElectricBorders" = {
          Bottom = "None";
          BottomLeft = "None";
          BottomRight = "None";
          Left = "None";
          Right = "None";
          Top = "None";
          TopLeft = "None";
          TopRight = "None";
        };
      };
      "kcminputrc" = {
        "Keyboard" = {
          RepeatDelay = 168;
          RepeatRate = 43;
        };
      };
    };
  };
  xdg.desktopEntries = lib.mkIf isNixos {
    brave-new-window = {
      name = "New Brave Window";
      genericName = "Web Browser";
      comment = "Open a new Brave window";
      exec = "brave --new-window";
      icon = "brave-browser";
      terminal = false;
      categories = [
        "Network"
        "WebBrowser"
      ];
    };
    kde-desktop-grid = {
      name = "Desktop Grid";
      genericName = "KWin Effect";
      comment = "Show the desktop grid view";
      exec = "qdbus6 org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut \"Grid View\"";
      icon = "preferences-desktop";
      terminal = false;
      categories = [ "Utility" ];
    };
    next-desktop = {
      name = "Next Desktop";
      genericName = "KWin Action";
      comment = "Switch to the next virtual desktop";
      exec = "next-desktop";
      icon = "preferences-desktop-workspaces";
      terminal = false;
      categories = [ "Utility" ];
    };
    prev-desktop = {
      name = "Previous Desktop";
      genericName = "KWin Action";
      comment = "Switch to the previous virtual desktop";
      exec = "prev-desktop";
      icon = "preferences-desktop-workspaces";
      terminal = false;
      categories = [ "Utility" ];
    };
    window-next-desktop = {
      name = "Window to Next Desktop";
      genericName = "KWin Action";
      comment = "Move the active window to the next virtual desktop";
      exec = "window-next-desktop";
      icon = "preferences-desktop-workspaces";
      terminal = false;
      categories = [ "Utility" ];
    };
    window-prev-desktop = {
      name = "Window to Previous Desktop";
      genericName = "KWin Action";
      comment = "Move the active window to the previous virtual desktop";
      exec = "window-prev-desktop";
      icon = "preferences-desktop-workspaces";
      terminal = false;
      categories = [ "Utility" ];
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      menu = "rofi -show drun";
      terminal = "kitty";
      keybindings =
        let
          mod = "Mod4";
        in
        {
          "${mod}+q" = "kill";
          "${mod}+space" = "exec rofi -show drun";
          "${mod}+Return" = "exec kitty";
          "Ctrl+Alt+space" = "layout toggle stacking splitv";
          "Ctrl+Alt+n" = "workspace next";
          "Ctrl+Alt+p" = "workspace prev";
          "Ctrl+Alt+t" = "floating toggle";
          "Ctrl+Alt+h" = "resize shrink width 50 px";
          "Ctrl+Alt+l" = "resize grow width 50 px";
        };
    };
  };

  home.file."Downloads/.keep".text = "";

  home.activation.createProjDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e "$HOME/proj" ] && [ ! -L "$HOME/proj" ]; then
      mkdir -p "$HOME/proj"
    fi
  '';
}
