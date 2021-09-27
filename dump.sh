#!/usr/bin/env bash

set -euo pipefail

# This script dumps a postgres database and upload it to a S3 bucket
#
# All inputs are from environment variables:
# S3_BUCKET: bucket in which to upload the dump
# PG_DUMP_OPTIONS: additional options to pass to pg_dump invocation, eg: "--clean --no-owner"
# DB_URL: postgres URL (postgres://user:pass@host/dbname)
# - OR -
# DB_NAME: database name
# DB_USER: username used to connect to postgres
# DB_PASS: password used for authentication
# DB_HOST: hostname of the postgres instance
#
# All necessary AWS settings should also be passed as environment variables.

if [ -z "${DB_URL}" ]; then
    DB_URL="postgresql://$DB_USER:$DB_PASS@$DB_HOST/$DB_NAME"
else
    DB_NAME=$(echo "$DB_URL" | sed -E 's|^.*\/([^?]*)\??.*$|\1|')
fi

output="$DB_NAME-$(date +%Y%m%d-%H%M).sql.gz"
options="${PG_DUMP_OPTIONS:-}"

pg_dump "$options" "$DB_URL" | gzip > "$output"
aws s3 cp "$output" "$S3_BUCKET"
