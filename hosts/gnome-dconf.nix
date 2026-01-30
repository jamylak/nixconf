# Moving this out here as I'm not currently using gnome
{ lib, ... }:
{
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      rotate-video-lock-static = [ ];
    };
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ ];
    };
    "org/gnome/shell/keybindings" = {
      open-application-menu = [ ];
      focus-active-notification = [ ];
      toggle-message-tray = [ ];
      show-clipboard = [ ];
      show-all-apps = [ ];
      toggle-application-view = [ ];
      toggle-overview = [ "<Super>space" ];
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      switch-to-application-5 = [ ];
      switch-to-application-6 = [ ];
      switch-to-application-7 = [ ];
      switch-to-application-8 = [ ];
      switch-to-application-9 = [ ];
    };
    "org/gnome/desktop/wm/keybindings" = {
      activate-window-menu = [ ];
      hide = [ ];
      minimize = [ ];
      close = [ "<Super>q" ];
      switch-input-source = [ ];
      switch-input-source-backward = [ ];
    };
    "org/gnome/desktop/peripherals/keyboard" = {
      delay = lib.hm.gvariant.mkUint32 168;
      repeat-interval = lib.hm.gvariant.mkUint32 23;
    };
    "org/gnome/desktop/default-applications/terminal" = {
      exec = "kitty";
      exec-arg = "";
    };
  };
}
