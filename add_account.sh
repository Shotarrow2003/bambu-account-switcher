#!/bin/bash
# ============================================================
#  Bambu Studio アカウント追加
#  使い方: bash add_account.sh [アカウント名]
#  https://github.com/Shotarrow2003/bambu-account-switcher
# ============================================================

APP_SUPPORT="$HOME/Library/Application Support"

# 引数があればそれを使う、なければ対話で入力
if [ -n "$1" ] && [ "$1" != "--no-mkdir" ]; then
  ACCOUNT_NAME="$1"
else
  echo "========================================"
  echo " Bambu Studio アカウント追加"
  echo "========================================"
  echo ""
  echo "追加するアカウントの名前を入力してください。"
  echo "（例: 家, 会社, personal, サブ など）"
  read -rp "アカウント名: " ACCOUNT_NAME
fi

if [ -z "$ACCOUNT_NAME" ]; then
  echo "❌ アカウント名を入力してください。"
  exit 1
fi

ACCOUNT_DATA="$APP_SUPPORT/BambuStudio_${ACCOUNT_NAME}"
SHORTCUT=~/Desktop/"${ACCOUNT_NAME}_BambuStudio.app"

# ── データフォルダを作成 ──────────────────────────────────
if [ "$2" != "--no-mkdir" ] && [ "$1" != "--no-mkdir" ]; then
  if [ -d "$ACCOUNT_DATA" ]; then
    echo "⚠️  「${ACCOUNT_NAME}」のフォルダはすでに存在します: $ACCOUNT_DATA"
  else
    mkdir -p "$ACCOUNT_DATA"
    echo "✅ データフォルダを作成しました: $ACCOUNT_DATA"
  fi
fi

# ── デスクトップにショートカットを生成 ────────────────────
osacompile -o "$SHORTCUT" << HEREDOC
do shell script "pkill -x BambuStudio; sleep 1; rm -f \"$APP_SUPPORT/BambuStudio\"; ln -s \"$ACCOUNT_DATA\" \"$APP_SUPPORT/BambuStudio\"; open /Applications/BambuStudio.app"
HEREDOC

echo "✅ デスクトップにショートカットを作成しました: ${ACCOUNT_NAME}_BambuStudio.app"
echo ""
echo "初回起動時にこのアカウントでログインしてください。"
