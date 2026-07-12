# Codex Multi-Profile Launcher for macOS

Run multiple isolated Codex desktop profiles on the same Mac without logging in and out.

This project creates Dock-friendly launchers for separate ChatGPT/Codex desktop app profiles. Each launcher gets its own:

- `CODEX_HOME`
- ChatGPT/Codex desktop app data directory
- login session
- Dock icon
- profile label, such as `C1` and `C2`

It is useful if you want:

- Codex multiple profiles
- Codex desktop separate accounts
- ChatGPT Codex desktop profiles
- multiple Codex accounts on macOS
- a Codex profile switcher without logging out
- isolated `CODEX_HOME` launchers
- separate Codex Business and personal profiles
- parallel Codex desktop sessions

## What Problem This Solves

The normal ChatGPT/Codex desktop app uses one default desktop profile. If you switch accounts inside that app, you interrupt the current login and workspace.

This repository creates two additional launcher apps:

```text
Codex C1 Business.app
Codex C2 David.app
```

Each launcher starts the installed ChatGPT/Codex desktop app with a different runtime boundary.

| Launcher | Codex CLI home | Desktop app data |
|---|---|---|
| Codex C1 Business | `~/.codex-business` | `~/Library/Application Support/Codex-C1-Business` |
| Codex C2 David | `~/.codex-david` | `~/Library/Application Support/Codex-C2-David` |
| Regular ChatGPT/Codex app | `~/.codex` | `~/Library/Application Support/Codex` |

The result is three distinct profiles: the original app plus C1 and C2.

## Requirements

- macOS
- The ChatGPT/Codex desktop app installed at `/Applications/ChatGPT.app`
- Codex CLI available on your `PATH`
- Bash, Python 3, `sips`, `iconutil`, and `qlmanage` (standard on macOS)

Check:

```bash
codex --version
ls -ld /Applications/ChatGPT.app
```

## Quick Start

Clone the repo:

```bash
git clone https://github.com/tbhrc/codex-multi-profile-launcher.git
cd codex-multi-profile-launcher
```

Bootstrap the isolated Codex homes:

```bash
bash scripts/bootstrap.sh
```

Create the Dock launcher apps:

```bash
bash scripts/install-macos-launchers.sh
```

Open `~/Applications`, then drag these apps to your Dock:

```text
Codex C1 Business.app
Codex C2 David.app
```

Launch each one and sign into the account you want for that profile.

## Custom Names

The default labels are:

- `C1` = Codex Business
- `C2` = Codex David

You can customize the launcher names during installation:

```bash
C1_APP_NAME="Codex C1 Work" \
C2_APP_NAME="Codex C2 Personal" \
bash scripts/install-macos-launchers.sh
```

You can also install to a different applications folder:

```bash
APPS_DIR="$HOME/Desktop" bash scripts/install-macos-launchers.sh
```

If your ChatGPT/Codex app is not in `/Applications/ChatGPT.app`:

```bash
CHATGPT_APP="/path/to/ChatGPT.app" bash scripts/install-macos-launchers.sh
```

## How It Works

The launchers do not copy your credentials. They only start the installed app with separate environment and Chromium/Electron user-data paths.

For C1:

```bash
export CODEX_HOME="$HOME/.codex-business"
exec /Applications/ChatGPT.app/Contents/MacOS/ChatGPT \
  --user-data-dir="$HOME/Library/Application Support/Codex-C1-Business"
```

For C2:

```bash
export CODEX_HOME="$HOME/.codex-david"
exec /Applications/ChatGPT.app/Contents/MacOS/ChatGPT \
  --user-data-dir="$HOME/Library/Application Support/Codex-C2-David"
```

The separate `--user-data-dir` is the important desktop-app part. `CODEX_HOME` isolates the Codex CLI/config/runtime side.

## Scripts

| Script | Purpose |
|---|---|
| `scripts/bootstrap.sh` | Creates the isolated Codex home folders and safe config files |
| `scripts/install-macos-launchers.sh` | Creates the two `.app` launchers and custom icons |
| `scripts/launch-codex-business-desktop.sh` | Launches C1 desktop profile |
| `scripts/launch-codex-david-desktop.sh` | Launches C2 desktop profile |
| `scripts/auth-codex-business.sh` | Runs CLI login for C1 |
| `scripts/auth-codex-david.sh` | Runs CLI login for C2 |
| `scripts/status.sh` | Shows login status for both isolated homes |

## Testing

Validate the bridge:

```bash
python3 tools/aosctl.py validate --verbose
python3 -m unittest tests/test_aosctl.py
```

Open C1 and verify the process:

```bash
open -n "$HOME/Applications/Codex C1 Business.app"
ps -axo pid,args | grep 'Codex-C1-Business'
```

You should see the app running with:

```text
--user-data-dir=/Users/<you>/Library/Application Support/Codex-C1-Business
```

## Security Notes

This project intentionally ignores credentials and local app state.

Do not commit:

- `auth.json`
- `.env`
- API keys
- copied app data
- `~/Library/Application Support/Codex*`

The repository includes `.gitignore` rules for common credential files, but you should still review before publishing your fork.

## Known Limitation

This is a macOS-first launcher pattern. It was tested with the ChatGPT/Codex desktop app on macOS.

If the app changes how it handles login or `--user-data-dir`, the launch scripts may need adjustment.

## License

MIT.
