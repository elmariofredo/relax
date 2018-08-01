FROM alpine:3.8

RUN apk add --no-cache git openssh curl

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v1.11.1/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl


ADD run.sh /

ENTRYPOINT [ "/run.sh" ]
