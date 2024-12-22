#!/bin/bash

# データベースが起動するまで待機
until mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -e "SELECT 1" >/dev/null 2>&1; do
    echo "Waiting for database connection..."
    sleep 5
done

while true; do
    # タイムスタンプを生成
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)

    # ファイル名のテンプレートを使用
    if [ -z "$BACKUP_FILENAME_TEMPLATE" ]; then
        BACKUP_FILENAME="backup_${TIMESTAMP}.sql.gz"
    else
        # テンプレート内の {timestamp} を実際の値に置換
        BACKUP_FILENAME=$(echo "${BACKUP_FILENAME_TEMPLATE}" | sed "s/{timestamp}/${TIMESTAMP}/g")
        # .gz 拡張子が含まれていない場合は追加
        [[ "$BACKUP_FILENAME" != *.gz ]] && BACKUP_FILENAME="${BACKUP_FILENAME}.gz"
    fi

    echo "Creating backup: ${BACKUP_FILENAME}"

    # データベースのダンプを作成し、直接gzipで圧縮
    mysqldump --no-tablespaces -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME | gzip > "/tmp/${BACKUP_FILENAME}"

    # S3にアップロード（Content-Typeを指定）
    aws --endpoint-url $S3_ENDPOINT s3 cp \
        "/tmp/${BACKUP_FILENAME}" \
        "s3://${S3_BUCKET}/${BACKUP_FILENAME}" \
        --content-type "application/gzip"

    # 一時ファイルを削除
    rm "/tmp/${BACKUP_FILENAME}"

    echo "Backup completed: ${BACKUP_FILENAME}"

    # 次のバックアップまで待機 (1日待機)
    sleep ${BACKUP_INTERVAL:-86400}
done
