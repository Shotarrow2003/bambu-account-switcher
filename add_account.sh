#!/bin/bash
# ============================================================
#  Bambu Studio アカウント追加 / Add Account
#  使い方 / Usage: bash add_account.sh [アカウント名 / account_name]
#  https://github.com/Shotarrow2003/bambu-account-switcher
# ============================================================

APP_SUPPORT="$HOME/Library/Application Support"

# 引数があればそれを使う、なければ対話で入力
# Use argument if provided, otherwise prompt interactively
if [ -n "$1" ] && [ "$1" != "--no-mkdir" ]; then
  ACCOUNT_NAME="$1"
else
  echo "========================================="
  echo " Bambu Studio アカウント追加 / Add Account"
  echo "========================================="
  echo ""
  echo "追加するアカウントの名前を入力してください。"
  echo "Enter a name for the new account."
  echo "（例 / e.g.: Home, Work, personal, Sub）"
  read -rp "アカウント名 / Account name: " ACCOUNT_NAME
fi

if [ -z "$ACCOUNT_NAME" ]; then
  echo "❌ アカウント名を入力してください。/ Account name is required."
  exit 1
fi

ACCOUNT_DATA="$APP_SUPPORT/BambuStudio_${ACCOUNT_NAME}"
SHORTCUT=~/Desktop/"${ACCOUNT_NAME}_BambuStudio.app"

# ── データフォルダを作成 / Create data folder ─────────────
if [ "$2" != "--no-mkdir" ] && [ "$1" != "--no-mkdir" ]; then
  if [ -d "$ACCOUNT_DATA" ]; then
    echo "⚠️  「${ACCOUNT_NAME}」のフォルダはすでに存在します: $ACCOUNT_DATA"
    echo "   Folder for \"${ACCOUNT_NAME}\" already exists: $ACCOUNT_DATA"
  else
    mkdir -p "$ACCOUNT_DATA"
    echo "✅ データフォルダを作成しました / Data folder created: $ACCOUNT_DATA"
  fi
fi

# ── デスクトップにショートカットを生成 / Create Desktop shortcut ──
osacompile -o "$SHORTCUT" << HEREDOC
do shell script "pkill -x BambuStudio; sleep 1; rm -f \"$APP_SUPPORT/BambuStudio\"; ln -s \"$ACCOUNT_DATA\" \"$APP_SUPPORT/BambuStudio\"; open /Applications/BambuStudio.app"
HEREDOC

echo "✅ デスクトップにショートカットを作成しました / Desktop shortcut created: ${ACCOUNT_NAME}_BambuStudio.app"
echo ""
echo "初回起動時にこのアカウントでログインしてください。"
echo "Please log in with this account on the first launch."
