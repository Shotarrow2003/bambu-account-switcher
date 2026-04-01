#!/bin/bash
# ============================================================
#  Bambu Studio アカウント切り替え アンインストール
#  https://github.com/Shotarrow2003/bambu-account-switcher
# ============================================================

APP_SUPPORT="$HOME/Library/Application Support"
CURRENT="$APP_SUPPORT/BambuStudio"

echo "========================================"
echo " Bambu Studio アカウント切り替え アンインストール"
echo "========================================"
echo ""

# ── BambuStudio を終了 ────────────────────────────────────
if pgrep -x "BambuStudio" > /dev/null; then
  echo "⚠️  BambuStudio を終了します..."
  pkill -x "BambuStudio"
  sleep 2
fi

# ── 現在どのアカウントが有効か確認 ───────────────────────
if [ -L "$CURRENT" ]; then
  ACTIVE=$(readlink "$CURRENT")
  ACTIVE_NAME=$(basename "$ACTIVE" | sed 's/BambuStudio_//')
  echo "現在有効なアカウント: ${ACTIVE_NAME}"
  echo ""
  echo "このアカウントのデータをメインの BambuStudio フォルダとして復元します。"
  read -rp "よろしいですか？ [y/N]: " confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "キャンセルしました。"
    exit 0
  fi
  rm -f "$CURRENT"
  mv "$ACTIVE" "$CURRENT"
  echo "✅ 「${ACTIVE_NAME}」のデータを BambuStudio フォルダとして復元しました"
else
  echo "✅ シムリンクは設定されていません（スキップ）"
fi

# ── 残りのアカウントフォルダを確認・削除 ─────────────────
echo ""
ACCOUNTS=("$APP_SUPPORT"/BambuStudio_*)
if [ -e "${ACCOUNTS[0]}" ]; then
  echo "以下のアカウントデータが残っています："
  for ACCOUNT in "${ACCOUNTS[@]}"; do
    echo "  - $(basename "$ACCOUNT" | sed 's/BambuStudio_//')"
  done
  echo ""
  read -rp "これらをすべて削除しますか？ [y/N]: " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    for ACCOUNT in "${ACCOUNTS[@]}"; do
      rm -rf "$ACCOUNT"
      echo "✅ 削除: $ACCOUNT"
    done
  else
    echo "⏭️  アカウントデータは残しました"
  fi
fi

# ── デスクトップのショートカットを削除 ───────────────────
echo ""
SHORTCUTS=(~/Desktop/*_BambuStudio.app)
if [ -e "${SHORTCUTS[0]}" ]; then
  for SHORTCUT in "${SHORTCUTS[@]}"; do
    rm -rf "$SHORTCUT"
    echo "✅ 削除: $(basename "$SHORTCUT")"
  done
fi

echo ""
echo "========================================"
echo " アンインストール完了！"
echo "========================================"
echo ""
echo "Bambu Studio は通常通り起動できます。"
