## KDE troubleshooting

```bash
nvim ~/.config/kglobalshortcutsrc
```

```bash
qdbus org.kde.KWin /KWin
```

```bash
rg -n "Meta\\+T|Super\\+T|Meta_T" ~/.config/kglobalshortcutsrc ~/.config/khotkeysrc ~/.config/kwinrc
```
