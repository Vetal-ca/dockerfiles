FROM alpine:3.11 as build
MAINTAINER "Vitali Khlebko vitali.khlebko@vetal.ca"

RUN apk update && apk add git make g++ perl pcre-dev libconfig-dev
#g++ make readline-dev zlib-dev perl bison flex linux-headers

ENV SSLH_TAG=v1.20

RUN cd /tmp &&\
    git clone https://github.com/yrutschle/sslh.git sslh &&\
    cd sslh &&\
    git checkout ${SSLH_TAG} &&\
    git config pull.rebase true &&\
    make &&\
    make install

FROM alpine:3.11

RUN apk update && apk add libconfig pcre && rm -rf /var/cache/apk/*

COPY --from=build /usr/sbin/sslh /usr/sbin/
COPY --from=build /usr/share/man/man8/sslh.8.gz /usr/share/man/man8/

ENTRYPOINT ["/usr/sbin/sslh", "-f", "-u", "root"]

#CMD sslh -f -u root -d $LISTEN_IP:$LISTEN_PORT --ssh $SSH_HOST:$SSH_PORT --ssl $HTTPS_HOST:$HTTPS_PORT --openvpn $OPENVPN_HOST:$OPENVPN_PORT