## Meta+T troubleshooting

If Super/Meta+T is still grabbed by KDE, find the exact shortcut entry with:

```bash
rg -n "Meta\\+T|Super\\+T|Meta_T" ~/.config/kglobalshortcutsrc ~/.config/khotkeysrc ~/.config/kwinrc
```

Then map that entry to `none` in `home.nix`.
