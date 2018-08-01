FROM alpine:3.8

RUN apk add --no-cache git openssh

ADD run.sh /

ENTRYPOINT [ "/run.sh" ]
