# 松江お菓子マップ 🗺️♨️

## プロジェクト概要

このアプリケーションは、島根県松江市の温泉を登録・閲覧できるWebアプリケーションです。

### 主な機能
- 🗺️ **温泉マップ表示**: 登録された温泉を地図上で確認できます
- ♨️ **温泉登録**: 新しい温泉スポットを登録できます
- ⭐ **レビュー機能**: 温泉にレビューを投稿できます
- 📱 **レスポンシブデザイン**: 複数の画面幅に対応しています

## 技術スタック

- **フレームワーク**: Ruby on Rails 8.x
- **データベース**: PostgreSQL（開発環境）
- **フロントエンド**: HTML, CSS(Tailwind CSS), JavaScript
- **地図**: Leaflet(Open Street Map)

## 開発環境のセットアップ

### 前提条件
- Docker Desktop がインストールされていること
- Visual Studio Code がインストールされていること
- Dev Containers 拡張機能がインストールされていること

### セットアップ手順

#### 1. リポジトリのクローン
```bash
git clone [リポジトリURL]
cd matsue-onsen-map
```

#### 2. Dev Container での開発環境起動
1. VS Code でプロジェクトフォルダを開く
2. `Ctrl+Shift+P` (macOS: `Cmd+Shift+P`) でコマンドパレットを開く
3. `Dev Containers: Reopen in Container` を選択
4. コンテナのビルドが完了するまで待つ

#### 3. 依存関係のインストール
コンテナ内で以下のコマンドを実行：
```bash
bundle install
```

#### 4. データベースのセットアップ
```bash
rails db:create
rails db:migrate
```

#### 5. アプリケーションの起動
```bash
rails server
```

ブラウザで `http://localhost:3000` にアクセスしてアプリケーションを確認できます。

## 初めてRuby/Railsを触る方へ

### Rubyとは？
Rubyは、日本人のまつもとゆきひろ氏が開発したプログラミング言語です。読みやすく書きやすい言語として知られています。

### Railsとは？
Ruby on Rails（通称Rails）は、Rubyで作られたWebアプリケーションフレームワークです。Webアプリケーションを効率的に開発するための機能が豊富に備わっています。

### 基本的なRailsコマンド
```bash
# サーバーを起動
rails server

# データベースを作成
rails db:create

# マイグレーションを実行
rails db:migrate

# コンソールを起動
rails console
```

## プロジェクト構造

```
matsue-onsen-map/
├── app/                    # アプリケーションのメインコード
│   ├── controllers/        # コントローラー（リクエスト処理）
│   ├── models/            # モデル（データベース操作）
│   ├── views/             # ビュー（画面表示）
│   └── assets/            # CSS、JavaScript、画像ファイル
├── config/                # 設定ファイル
├── db/                    # データベース関連ファイル
├── Gemfile                # Rubyライブラリの依存関係
└── README.md              # このファイル
```

## 開発の流れ

1. **機能の追加**: 新しい温泉登録機能を追加する場合
2. **モデルの作成**: `rails generate model` でデータベーステーブルを作成
3. **コントローラーの作成**: `rails generate controller` で画面処理を作成
4. **ビューの作成**: HTMLテンプレートを作成
5. **テスト**: 機能が正しく動作するかテスト

## 困ったときは

- **Rails公式ガイド**: https://railsguides.jp/
- **Ruby公式サイト**: https://www.ruby-lang.org/ja/
- **Dev Containers公式ドキュメント**: https://containers.dev/

## ライセンス

このプロジェクトは学習目的で作成されています。

## 貢献

バグ報告や機能提案は、GitHubのIssueでお気軽にお知らせください！

---

**Happy Coding! 🚀**
