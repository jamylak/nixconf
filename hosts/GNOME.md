# GNOME
## Keybindings
  - Dump everything and grep

  ```sh
  dconf dump / | rg -i 'super.*o|<super>o|rotate-video-lock-static'
  ```

  - List all schemas, then search all recursively:

  ```sh
  gsettings list-schemas | while read -r s; do gsettings list-recursively "$s"; done | rg -i 'super.*o|<super>o|rotate-video-lock-static'
  ```
