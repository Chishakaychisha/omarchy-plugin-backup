# Omarchy Plugin Backup

Create a portable backup of your user-installed Omarchy shell plugins, then restore them after a reinstall.

## What it saves

- each user plugin's Git origin URL and exact commit;
- a copy of `~/.config/omarchy/shell.json` (bar layout, enabled plugins, and settings);
- optionally, Git patches for tracked local edits.

It deliberately does **not** copy credentials, package-manager state, or arbitrary files from your home directory. A plugin without a Git origin is recorded as requiring a manual copy.

## Install

```bash
omarchy plugin add https://github.com/Chishakaychisha/omarchy-plugin-backup.git --enable
```

## Export

```bash
./bin/export-plugins --output ~/Documents
./bin/export-plugins --output ~/Documents --include-local-changes
```

This creates `omarchy-plugin-backup-<timestamp>.tar.gz`.

## Restore

On the new Omarchy installation, clone this repository and run:

```bash
./bin/restore-plugins ~/Documents/omarchy-plugin-backup-<timestamp>.tar.gz
```

That restores plugin repositories and pins them to the exported commits. To also replace the current bar layout and enabled-state configuration:

```bash
./bin/restore-plugins ~/Documents/omarchy-plugin-backup-<timestamp>.tar.gz --replace-shell-config
```

`--replace-shell-config` saves the current config as `shell.json.before-plugin-backup-restore` first.

## Development

```bash
omarchy plugin validate .
```

Plugins execute as your user account. Review a backup archive before restoring it, especially one produced on another computer.

## License

MIT
