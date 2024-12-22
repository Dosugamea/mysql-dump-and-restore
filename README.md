## MySQL Backup and Restore with S3
データベースのバックアップとリストアを S3 互換ストレージで管理する Docker コンテナセット

### 機能
- MySQL データベースの定期バックアップ
- gzip 圧縮によるバックアップサイズの最適化
- カスタマイズ可能なバックアップファイル名
- S3 互換ストレージへのアップロード
- バックアップからのデータベース復元
- ARM64/AMD64 アーキテクチャ対応

## セットアップ

### バックアップの実行
- dump/docker-compose.yml 参照
- または dosugamea/mysql-dump-s3-alpine:1.0.0 使用

### リストアの実行
- restore/docker-compose.yml 参照
- または dosugamea/mysql-restore-s3-alpine:1.0.0 使用

### 環境変数

| 変数名 | 説明 | デフォルト値 |
|--------|------|--------------|
| DB_HOST | データベースホスト名 | - |
| DB_NAME | データベース名 | - |
| DB_USER | データベースユーザー | - |
| DB_PASSWORD | データベースパスワード | - |
| DB_ROOT_PASSWORD | MySQLのroot パスワード | - |
| S3_ENDPOINT | S3互換ストレージのエンドポイント | - |
| S3_BUCKET | バックアップを保存するバケット名 | - |
| AWS_ACCESS_KEY_ID | S3アクセスキー | - |
| AWS_SECRET_ACCESS_KEY | S3シークレットキー | - |
| AWS_DEFAULT_REGION | AWSリージョン | us-east-1 |
| BACKUP_INTERVAL | バックアップ間隔（秒） | 86400 |
| BACKUP_FILENAME_TEMPLATE | バックアップファイル名のテンプレート | backup_{timestamp} |
| BACKUP_FILE | リストア時に使うバックアップファイル名 | - |

### 注意事項
- バックアップファイルは自動的に gzip 圧縮されます
- リストア時はデータベースが空である必要があります
- S3互換ストレージへの適切なアクセス権限が必要です
- 大規模なデータベースの場合、バックアップとリストアに時間がかかる場合があります

### License
MIT

### Author
Perplexity pro / Claude 3.5 Sonnet