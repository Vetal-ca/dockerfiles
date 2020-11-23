FROM alpine:3.12

# tag="vetalca/alpine-curl:7.69.1"
# docker build --force-rm --tag "${tag}" . && docker push "${tag}"

RUN apk update && apk add curl jq && rm -rf /var/cache/apk/*
