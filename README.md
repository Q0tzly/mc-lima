# mc-lima

> **Lima** と **mise** だけで macOS 上に手軽に構築できる Minecraft サーバー環境。

macOS 上で Docker Desktop 等のツールを必要とせず、軽量な Linux 仮想マシン（Lima）とコンテナ技術を組み合わせて、コマンド一発で立ち上がる快適な Minecraft サーバー環境を提供します。

---

## 特長

- 🚀 **コマンド一発で起動**: `mise run up` だけで VM 作成から Minecraft サーバー起動まで全自動。
- 🛠️ **ツール管理は mise だけ**: プロジェクトで必要なツールは `mise` が管理するため、ホストを汚しません。
- 🎮 **多彩なサーバー種別に対応**: PaperMC（デフォルト・推奨）、Fabric、Purpur、Vanilla、Forge 等を `.env` 一行で切り替え可能。
- 📂 **Mac から直接ワールド・プラグインを編集**: ホスト側の `./data` フォルダにワールドや `server.properties`、プラグインがマウントされるため、Finder や VS Code から即座に編集可能。
- 💬 **対話コンソール & RCON**: `mise run console` でサーバーコンソールに即接続。ゲーム内コマンドを直接実行可能。
- 📦 **自動バックアップ**: `mise run backup` でタイムスタンプ付きのアーカイブをワンショット作成。

---

## 前提条件

- macOS (Apple Silicon / Intel, macOS 13+ 推奨)
- [mise](https://mise.jdx.dev/) がインストールされていること

---

## クイックスタート

```bash
# 1. リポジトリをクローンして移動
cd mc-lima

# 2. 初期設定ファイルの生成 (初回のみ)
mise run init

# 3. サーバー起動 (Lima VM の初期化とコンテナ起動)
mise run up
```

起動が完了すると、お使いの Minecraft クライアント（Java版）から **`localhost:25565`** に接続してプレイできます！

---

## 提供タスク一覧 (`mise run <task>`)

すべての操作は `mise run` 経由で実行できます。

| コマンド | 説明 |
| :--- | :--- |
| `mise run up` | Lima VM および Minecraft サーバーを起動します。 |
| `mise run down` | サーバーを安全に停止し、Lima VM をシャットダウンして Mac のリソースを全解放します。<br>※ VM を落とさずサーバーコンテナのみ停止する場合は `--keep-vm` を付与。 |
| `mise run status` | VM、コンテナ、サーバーの稼働状態、リッスンポート、設定概要を表示します。 |
| `mise run logs` | サーバーログをストリーミング表示します（Ctrl+C で抜けます）。 |
| `mise run console` | サーバーコンソールに対話的に接続します（`rcon-cli`）。`quit` で抜けます。 |
| `mise run rcon "<cmd>"` | ワンショットで Minecraft コマンドを実行します（例: `mise run rcon "op Alice"`）。 |
| `mise run restart` | Minecraft サーバーコンテナを再起動します（設定変更の反映など）。 |
| `mise run backup` | ワールドデータをフラッシュし、`./backups/` にタイムスタンプ付きアーカイブを作成します。 |
| `mise run shell` | Lima VM 内部の Linux シェルに対話的に入ります（トラブルシューティング用）。 |
| `mise run destroy` | Lima VM を完全削除します（`./data` のワールドデータは保持されます）。 |

---

## 設定とカスタマイズ (`.env`)

初回起動時に生成される `.env` を編集することで、サーバーの動作を自在に調整できます。

```bash
# ==========================================
# Minecraft サーバー設定
# ==========================================
SERVER_TYPE=PAPER            # PAPER (推奨), PURPUR, FABRIC, VANILLA, FORGE, NEOFORGE, SPIGOT
SERVER_VERSION=LATEST        # LATEST または 1.21.4, 1.20.4 など
MEMORY=4G                    # サーバーに割り当てる Java メモリ
SERVER_PORT=25565            # ホスト公開ポート
MOTD="Minecraft Server on Lima"
DIFFICULTY=normal            # peaceful, easy, normal, hard
MAX_PLAYERS=20               # 最大接続人数
ONLINE_MODE=TRUE             # 正規認証（TRUE）またはオフライン（FALSE）
OPS=Player1,Player2          # 初回起動時に自動で OP 権限を付与するユーザー名

# ==========================================
# Lima VM リソース割り当て
# ==========================================
VM_CPUS=4                    # VM に割り当てる CPU コア数
VM_MEMORY=6GiB               # VM に割り当てるメモリ (MEMORY より多めに設定)
VM_DISK=30GiB                # VM 仮想ディスクサイズ
```

設定を変更した場合は `mise run restart` でコンテナを再起動してください。

---

## プラグイン / Mod / 設定ファイルの管理

初回起動後、プロジェクトルートの `./data` に以下のファイル群が自動生成されます。

- **プラグインの追加 (Paper / Spigot / Purpur)**: `./data/plugins/` に `.jar` ファイルを配置して `mise run restart`
- **Mod の追加 (Fabric / Forge)**: `./data/mods/` に `.jar` ファイルを配置して `mise run restart`
- **詳細設定**: `./data/server.properties` や Paper の設定ファイル（`config/`）を通常のエディタで直接編集して `mise run restart`

---

## よくある質問 / トラブルシューティング

### Q. 初回起動に少し時間がかかるのはなぜですか？
Lima VM のベースイメージ（Ubuntu LTS）のダウンロード、Docker のプロビジョニング、および初回 Minecraft サーバー jar のダウンロードが実行されるためです。2 回目以降の起動は数秒〜十数秒で完了します。

### Q. Mac のポート `25565` が既に使用されていると怒られます
他の Minecraft サーバーやローカルプロセスがポート 25565 を掴んでいる可能性があります。`.env` の `SERVER_PORT` を `25566` などに変更してください。

### Q. VM をクリーンに作り直したい
```bash
mise run destroy
mise run up
```
ホストの `./data` フォルダはそのまま保護されるため、ワールドデータを失うことなく VM を再作成できます。
