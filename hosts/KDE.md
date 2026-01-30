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

```bash
loginctl terminate-user "$USER"
```

```bash
kquitapp6 plasmashell; kstart6 plasmashell
```
