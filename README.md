# PG S3 Dumper

Once instanciated, this container will dump the target database and export it gzipped on S3 bucket.

Expected environment variables:

- DB_NAME: database name
- DB_USER: username used to connect to postgres
- DB_PASS: password used for authentication
- DB_HOST: hostname of the postgres instance
- S3_BUCKET: bucket in which to upload the dump

And any other env var aws-cli might expect.


Example use case as a k8s cron job:

```yaml
---
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: pg-s3-dump-secret
stringData:
  AWS_ACCESS_KEY_ID: "XXXX"
  AWS_SECRET_ACCESS_KEY: "XXXXX"
  DB_USER: "XXXXX"
  DB_PASS: "XXXXX"
---
apiVersion: batch/v1
kind: CronJob
metadata:
  name: pg-s3-dump-cron-job
spec:
  schedule: "0 */2 * * *"
  jobTemplate:
    spec:
      backoffLimit: 3
      ttlSecondsAfterFinished: 300
      template:
        spec:
          containers:
          - name: pg-s3-dumper
            image: ghcr.io/mblottiere/pg-s3-dumper:main
            envFrom:
              - secretRef:
                  name: pg-s3-dump-secret
            env:
              - name: S3_BUCKET
                value: "s3://XXXXXXXXX/dumps/"
              - name: DB_NAME
                value: postgres
              - name: DB_HOST
                value: postgresql-0
            imagePullPolicy: IfNotPresent
          restartPolicy: OnFailure
```
