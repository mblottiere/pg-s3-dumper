#!/usr/bin/env bash

set -euo pipefail

# This script dumps a postgres database and upload it to a S3 bucket
#
# All inputs are from environment variables:
# DB_NAME: database name
# DB_USER: username used to connect to postgres
# DB_PASS: password used for authentication
# DB_HOST: hostname of the postgres instance
# S3_BUCKET: bucket in which to upload the dump
#
# All necessary AWS settings should also be passed as environment variables.

output="$DB_NAME-$(date +%Y%m%d-%H%M).sql.gz"

DB_URL="postgresql://$DB_USER:$DB_PASS@$DB_HOST/$DB_NAME"
pg_dump "$DB_URL" | gzip > "$output"
aws s3 cp "$output" "$S3_BUCKET"
