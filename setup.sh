#!/bin/bash
# ============================================================
#  Bambu Studio アカウント切り替えセットアップ
#  Bambu Studio Account Switcher Setup
#  https://github.com/Shotarrow2003/bambu-account-switcher
# ============================================================

APP_SUPPORT="$HOME/Library/Application Support"
CURRENT="$APP_SUPPORT/BambuStudio"

echo "========================================="
echo " Bambu Studio アカウント切り替えセットアップ"
echo " Bambu Studio Account Switcher Setup"
echo "========================================="
echo ""

# ── BambuStudio.app の確認 / Check for BambuStudio.app ────
if [ ! -d "/Applications/BambuStudio.app" ]; then
  echo "❌ /Applications/BambuStudio.app が見つかりません。"
  echo "   BambuStudio.app not found."
  echo "   先に Bambu Studio をインストールしてください。"
  echo "   Please install Bambu Studio first."
  exit 1
fi
echo "✅ BambuStudio.app を確認しました / BambuStudio.app found"
echo ""

# ── 最初のアカウント名を入力 / Enter your first account name ──
echo "現在ログイン中のアカウントの名前を入力してください。"
echo "Enter a name for the currently logged-in account."
echo "（例 / e.g.: Home, Work, personal）"
read -rp "アカウント名 / Account name: " ACCOUNT_NAME

if [ -z "$ACCOUNT_NAME" ]; then
  echo "❌ アカウント名を入力してください。/ Account name is required."
  exit 1
fi

ACCOUNT_DATA="$APP_SUPPORT/BambuStudio_${ACCOUNT_NAME}"

# ── 現在のデータを保存 / Save current data ────────────────
if [ -d "$CURRENT" ] && [ ! -L "$CURRENT" ]; then
  echo ""
  echo "📦 現在のデータを「${ACCOUNT_NAME}」として保存中..."
  echo "   Saving current data as \"${ACCOUNT_NAME}\"..."
  cp -R "$CURRENT" "$ACCOUNT_DATA"
  rm -rf "$CURRENT"
  ln -s "$ACCOUNT_DATA" "$CURRENT"
  echo "✅ 保存完了 / Saved: $ACCOUNT_DATA"
elif [ -L "$CURRENT" ]; then
  echo "✅ すでにシムリンク済みです（セットアップ済み）"
  echo "   Already symlinked (setup was already done)"
else
  mkdir -p "$ACCOUNT_DATA"
  ln -s "$ACCOUNT_DATA" "$CURRENT"
fi

# ── デスクトップにショートカットを生成 / Create Desktop shortcut ──
echo ""
echo "🖥️  デスクトップにショートカットを作成中..."
echo "   Creating Desktop shortcut..."
bash "$(dirname "$0")/add_account.sh" "$ACCOUNT_NAME" --no-mkdir

echo ""
echo "========================================="
echo " セットアップ完了！ / Setup complete!"
echo "========================================="
echo ""
echo "アカウントを追加するには / To add more accounts:"
echo "  bash add_account.sh"
echo ""
