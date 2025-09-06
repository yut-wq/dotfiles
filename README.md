# 🏠 dotfiles

個人的な設定ファイル集

## 🚀 セットアップ

### 1. 依存関係のインストール

```bash
./install.sh
```

このスクリプトは以下をインストールします：

- [uv](https://github.com/astral-sh/uv) - Python パッケージマネージャー
- [pyenv](https://github.com/pyenv/pyenv) - Python 版バージョン管理
- [ripgrep](https://github.com/BurntSushi/ripgrep) - 高速 grep
- [lazygit](https://github.com/jesseduffield/lazygit) - Git TUI

### 2. シンボリックリンクの作成

```bash
./makeLinks.sh
```

dotfiles ディレクトリ内の設定ファイルをホームディレクトリにシンボリックリンクとして配置します。

### 3. Windows 用（オプション）

```bash
./copy_to_windows.sh
```

## ⚙️ カスタマイズ

設定をカスタマイズしたい場合は、各設定ファイルを直接編集してください。
変更はシンボリックリンクにより自動的に反映されます。

## 📋 注意事項

- 既存の設定ファイルがある場合は、バックアップを取ることをお勧めします
- `makeLinks.sh`は既存のファイルを上書きします

## 🛠️ 要件

- Linux/macOS 環境
- Bash/Zsh
- Git
