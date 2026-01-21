# GNOME
## Keybindings
  - Dump everything and grep

  ```fish
  dconf dump / | rg -i 'super.*o|<super>o|rotate-video-lock-static'
  ```

  - List all schemas, then search all recursively:

  ```fish
  gsettings list-schemas | while read -l s
    gsettings list-recursively $s
  end | rg -i 'super.*o|<super>o|rotate-video-lock-static'
  ```
