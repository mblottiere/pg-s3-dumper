FROM alpine:3.14

RUN apk add --no-cache bash postgresql-client aws-cli gzip

COPY ./dump.sh /usr/local/bin/dump

CMD /usr/local/bin/dump
