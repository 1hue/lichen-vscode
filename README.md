# Lichen - VS Code theme

Lichen greens on near-black blue. Less chaos.

Syntax colors based on [Tokyo Night](https://github.com/tokyo-night/tokyo-night-vscode-theme).

## Usage

Search "Lichen" in Extensions.

### Manual

You don't actually need to install anything if you don't want to.

Paste [settings.json](.vscode/settings.json) into `Ctrl+Shift+P` -> `Preferences: Open User Settings (JSON)` for the exact look in screenshots. Or pick what you like only:

| File                                  |                                                    |
| ------------------------------------- | -------------------------------------------------- |
| [colors.json](.vscode/colors.json)    | Colors only                                        |
| [layout.json](.vscode/layout.json)    | Tab style, tree indent, breadcrumbs and other bits |

> [!NOTE]
> Manual copy includes:
>
> ```json
> "editor.fontFamily": "'JetBrains Mono', 'Google Sans Code', monospace",
> "editor.fontSize": 12.5,
> "editor.formatOnSave": true,
> "window.zoomLevel": 0.2
> ```
> Make sure this is what you want.

## License

- [MIT](LICENSE)
- Tokyo Night parts under their own [MIT license](LICENSE-tokyo-night)
