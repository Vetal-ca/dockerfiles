FROM alpine:3.12 as build
MAINTAINER "Vitali Khlebko vitali.khlebko@vetal.ca"

ENV OPENVPN_VERSION=2.5.0
RUN cd /tmp && wget https://swupdate.openvpn.org/community/releases/openvpn-${OPENVPN_VERSION}.tar.gz &&\
    tar -xzf openvpn-${OPENVPN_VERSION}.tar.gz && cd openvpn-${OPENVPN_VERSION}

RUN apk update && apk add build-base linux-headers openssl-dev lzo-dev linux-pam-dev

RUN cd /tmp/openvpn-${OPENVPN_VERSION} &&\
    ./configure	--prefix=/usr/local/openvpn \
               	 --libdir=/usr/local/openvpn/lib64 \
               	--enable-shared \
               	--enable-server \
               	--with-gnu-ld \
               	--with-crypto-library=openssl \
               	--enable-crypto \
               	--enable-x509-alt-username \
               	--enable-iproute2 \
               	--with-mem-check=no \
               	--enable-lzo \
               	--enable-lz4 &&\
    make &&\
    make install

FROM alpine:3.12

COPY --from=build /usr/local/openvpn /usr/local/openvpn

RUN apk update && apk add lzo && ln -s /usr/local/openvpn/sbin/openvpn /usr/bin/openvpn && rm -rf /var/cache/apk/*





#    ./configure	--prefix=/usr/local/openvpn \
#               	 --libdir=/usr/local/openvpn/lib64 \
#               	--enable-shared --disable-static \
#               	--with-gnu-ld \
#               	--with-crypto-library=openssl \
#               	--enable-crypto \
#               	--enable-x509-alt-username \
#               	--disable-multihome \
#               	--enable-iproute2 \
#               	--with-mem-check=no \
#               	--disable-selinux \
#               	--enable-lzo \
#               	--enable-lz4