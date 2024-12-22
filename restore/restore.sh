#!/bin/bash

# データベースが起動するまで待機
until mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -e "SELECT 1" >/dev/null 2>&1; do
    echo "Waiting for database connection..."
    sleep 5
done

# 特定のバックアップファイルが指定されている場合はそれを使用
if [ ! -z "$BACKUP_FILE" ]; then
    aws --endpoint-url $S3_ENDPOINT s3 cp "s3://${S3_BUCKET}/${BACKUP_FILE}" /tmp/restore.sql.gz
else
    # 最新のバックアップファイルを取得
    LATEST_BACKUP=$(aws --endpoint-url $S3_ENDPOINT s3 ls "s3://${S3_BUCKET}/" | sort | tail -n 1 | awk '{print $4}')
    aws --endpoint-url $S3_ENDPOINT s3 cp "s3://${S3_BUCKET}/${LATEST_BACKUP}" /tmp/restore.sql.gz
fi

# データベースを復元
# gzipファイルを解凍してMySQLにリストア
gzip -dc /tmp/restore.sql.gz | mysql -h $DB_HOST \
    -u $DB_USER \
    -p$DB_PASSWORD \
    $DB_NAME

# 一時ファイルを削除
rm /tmp/restore.sql.gz

echo "Database restore completed successfully!"
