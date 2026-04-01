#!/bin/bash
# ============================================================
#  Bambu Studio アカウント切り替え アンインストール
#  Bambu Studio Account Switcher Uninstall
#  https://github.com/Shotarrow2003/bambu-account-switcher
# ============================================================

APP_SUPPORT="$HOME/Library/Application Support"
CURRENT="$APP_SUPPORT/BambuStudio"

echo "========================================="
echo " Bambu Studio アカウント切り替え アンインストール"
echo " Bambu Studio Account Switcher Uninstall"
echo "========================================="
echo ""

# ── BambuStudio を終了 / Quit BambuStudio ─────────────────
if pgrep -x "BambuStudio" > /dev/null; then
  echo "⚠️  BambuStudio を終了します... / Quitting BambuStudio..."
  pkill -x "BambuStudio"
  sleep 2
fi

# ── 現在どのアカウントが有効か確認 / Check active account ──
if [ -L "$CURRENT" ]; then
  ACTIVE=$(readlink "$CURRENT")
  ACTIVE_NAME=$(basename "$ACTIVE" | sed 's/BambuStudio_//')
  echo "現在有効なアカウント / Currently active account: ${ACTIVE_NAME}"
  echo ""
  echo "このアカウントのデータをメインの BambuStudio フォルダとして復元します。"
  echo "This account's data will be restored as the main BambuStudio folder."
  read -rp "よろしいですか？/ Proceed? [y/N]: " confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "キャンセルしました。/ Cancelled."
    exit 0
  fi
  rm -f "$CURRENT"
  mv "$ACTIVE" "$CURRENT"
  echo "✅ 「${ACTIVE_NAME}」のデータを BambuStudio フォルダとして復元しました"
  echo "   Restored \"${ACTIVE_NAME}\" data as the BambuStudio folder"
else
  echo "✅ シムリンクは設定されていません（スキップ）"
  echo "   No symlink configured (skipped)"
fi

# ── 残りのアカウントフォルダを確認・削除 / Check & delete remaining accounts ──
echo ""
ACCOUNTS=("$APP_SUPPORT"/BambuStudio_*)
if [ -e "${ACCOUNTS[0]}" ]; then
  echo "以下のアカウントデータが残っています："
  echo "The following account data remains:"
  for ACCOUNT in "${ACCOUNTS[@]}"; do
    echo "  - $(basename "$ACCOUNT" | sed 's/BambuStudio_//')"
  done
  echo ""
  read -rp "これらをすべて削除しますか？/ Delete all? [y/N]: " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    for ACCOUNT in "${ACCOUNTS[@]}"; do
      rm -rf "$ACCOUNT"
      echo "✅ 削除 / Deleted: $ACCOUNT"
    done
  else
    echo "⏭️  アカウントデータは残しました / Account data kept"
  fi
fi

# ── デスクトップのショートカットを削除 / Remove Desktop shortcuts ──
echo ""
SHORTCUTS=(~/Desktop/*_BambuStudio.app)
if [ -e "${SHORTCUTS[0]}" ]; then
  for SHORTCUT in "${SHORTCUTS[@]}"; do
    rm -rf "$SHORTCUT"
    echo "✅ 削除 / Deleted: $(basename "$SHORTCUT")"
  done
fi

echo ""
echo "========================================="
echo " アンインストール完了！ / Uninstall complete!"
echo "========================================="
echo ""
echo "Bambu Studio は通常通り起動できます。"
echo "You can now launch Bambu Studio normally."
