#!/bin/bash
# ============================================================
#  Bambu Studio アカウント切り替えセットアップ
#  https://github.com/Shotarrow2003/bambu-account-switcher
# ============================================================

APP_SUPPORT="$HOME/Library/Application Support"
CURRENT="$APP_SUPPORT/BambuStudio"

echo "========================================"
echo " Bambu Studio アカウント切り替えセットアップ"
echo "========================================"
echo ""

# ── BambuStudio.app の確認 ─────────────────────────────────
if [ ! -d "/Applications/BambuStudio.app" ]; then
  echo "❌ /Applications/BambuStudio.app が見つかりません。"
  echo "   先に Bambu Studio をインストールしてください。"
  exit 1
fi
echo "✅ BambuStudio.app を確認しました"
echo ""

# ── 最初のアカウント名を入力 ──────────────────────────────
echo "現在ログイン中のアカウントの名前を入力してください。"
echo "（例: 家, 会社, personal など）"
read -rp "アカウント名: " ACCOUNT_NAME

if [ -z "$ACCOUNT_NAME" ]; then
  echo "❌ アカウント名を入力してください。"
  exit 1
fi

ACCOUNT_DATA="$APP_SUPPORT/BambuStudio_${ACCOUNT_NAME}"

# ── 現在のデータを保存 ────────────────────────────────────
if [ -d "$CURRENT" ] && [ ! -L "$CURRENT" ]; then
  echo ""
  echo "📦 現在のデータを「${ACCOUNT_NAME}」として保存中..."
  cp -R "$CURRENT" "$ACCOUNT_DATA"
  rm -rf "$CURRENT"
  ln -s "$ACCOUNT_DATA" "$CURRENT"
  echo "✅ 保存完了: $ACCOUNT_DATA"
elif [ -L "$CURRENT" ]; then
  echo "✅ すでにシムリンク済みです（セットアップ済み）"
else
  mkdir -p "$ACCOUNT_DATA"
  ln -s "$ACCOUNT_DATA" "$CURRENT"
fi

# ── デスクトップにショートカットを生成 ────────────────────
echo ""
echo "🖥️  デスクトップにショートカットを作成中..."
bash "$(dirname "$0")/add_account.sh" "$ACCOUNT_NAME" --no-mkdir

echo ""
echo "========================================"
echo " セットアップ完了！"
echo "========================================"
echo ""
echo "アカウントを追加するには："
echo "  bash add_account.sh"
echo ""
