FROM vetalca/openvpn:2.5.0

# inspired by https://github.com/ventz/docker-openvpn
#

RUN apk update && apk add iptables && mkdir /scripts && rm -rf /var/cache/apk/*

WORKDIR /etc/openvpn

COPY entrypoint.sh /scripts/

ENTRYPOINT ["/scripts/entrypoint.sh"]