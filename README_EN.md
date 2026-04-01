# Bambu Studio — Switch Between Multiple Accounts on Mac

A setup guide to enable **one-click switching between multiple accounts** in Bambu Studio.
You can add as many accounts as you like — not just two.

---

## Why This Is Harder Than It Sounds

If you've stumbled upon this problem before, you may have tried the following approaches — **none of which work with Bambu Studio**.

| Attempted Method | Why It Doesn't Work |
|---|---|
| `--datadir` option | Commented out in the source code; has no effect |
| Modifying `Info.plist` in a copied `.app` | `SetAppName()` is hardcoded in the binary and overrides the plist |
| Changing the `HOME` environment variable and launching the binary directly | macOS resolves the user directory via `NSSearchPathForDirectoriesInDomains`, which ignores `HOME` |

---

## The Solution: Symlink Swap

Bambu Studio stores all its data in a **fixed** location:

```
~/Library/Application Support/BambuStudio/
```

The trick is to turn this folder into a **symlink** and swap its target at launch time.

```
~/Library/Application Support/
  BambuStudio              ← symlink (swapped on launch)
  BambuStudio_Home/        ← actual data for "Home" account
  BambuStudio_Work/        ← actual data for "Work" account
  BambuStudio_Sub/         ← add as many accounts as you want
```

---

## Setup Instructions

### 1. Clone This Repository

```bash
git clone https://github.com/Shotarrow2003/bambu-account-switcher.git
cd bambu-account-switcher
```

### 2. Run the Setup Script

```bash
bash setup.sh
```

You'll be prompted to enter an account name (e.g., `Home`).
The script will:
- Save your currently logged-in data as the named account
- Create a launch shortcut on your Desktop

### 3. Add More Accounts

```bash
bash add_account.sh
```

Enter an account name, and a data folder + Desktop shortcut will be created.
Repeat as many times as needed.

### 4. Done!

You'll find `AccountName_BambuStudio.app` on your Desktop.
Just double-click to switch and launch.

**First time only**: Launch each account's shortcut and log in. After that, no further login is needed.

---

## Notes

- You **cannot run multiple instances** simultaneously (the existing Bambu Studio process is automatically terminated when switching)
- Requires `/Applications/BambuStudio.app` to be installed
- Account data is **never deleted** — only the symlink target is changed

---

## Uninstall

```bash
bash uninstall.sh
```

This will:
- Restore the symlink back to a real folder
- Prompt you to delete remaining account data (optional, per-account)
- Remove all Desktop shortcuts
