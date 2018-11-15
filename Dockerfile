FROM alpine:3.8

RUN apk add --no-cache git openssh

ADD https://storage.googleapis.com/kubernetes-release/release/v1.11.1/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

ADD run.sh /

ENTRYPOINT [ "/run.sh" ]
