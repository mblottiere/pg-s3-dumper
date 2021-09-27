FROM postgres:13

RUN apt-get update && apt-get install awscli -y && apt-get clean

COPY ./dump.sh /usr/local/bin/dump

CMD /usr/local/bin/dump
