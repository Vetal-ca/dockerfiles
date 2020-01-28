FROM alpine:3.11 as build
MAINTAINER "Vitali Khlebko vitali.khlebko@vetal.ca"

ENV NGINX_VERSION nginx-1.17.8

RUN apk --update add openssl-dev pcre-dev zlib-dev wget build-base git geoip-dev expat-dev libxslt-dev libxml2-dev && \
    mkdir -p /tmp/src && \
    cd /tmp/src && \
    wget http://nginx.org/download/${NGINX_VERSION}.tar.gz && \
    tar -zxvf ${NGINX_VERSION}.tar.gz


ENV MODULESDIR /tmp/src/nginx-modules

RUN git clone https://github.com/arut/nginx-dav-ext-module ${MODULESDIR}/nginx-dav-ext-module && \
    git clone https://github.com/vkholodkov/nginx-upload-module.git ${MODULESDIR}/nginx-upload-module && \
    git clone https://github.com/masterzen/nginx-upload-progress-module.git ${MODULESDIR}/nginx-upload-progress-module && \
    git clone https://github.com/openresty/headers-more-nginx-module.git ${MODULESDIR}/nginx-headers-more-module

# https://github.com/openresty/headers-more-nginx-module#installation
RUN cd /tmp/src/${NGINX_VERSION} && \
    ./configure \
        --prefix=/etc/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --sbin-path=/usr/sbin \
        --http-client-body-temp-path=/var/lib/nginx/body \
        --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
        --http-log-path=/var/log/nginx/access.log \
        --http-proxy-temp-path=/var/lib/nginx/proxy \
        --http-scgi-temp-path=/var/lib/nginx/scgi \
        --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
        --lock-path=/var/lock/nginx.lock \
        --pid-path=/var/run/nginx.pid \
        --with-http_addition_module \
        --with-http_geoip_module \
        --with-http_gzip_static_module \
        --with-http_realip_module \
        --with-http_stub_status_module \
        --with-http_ssl_module \
        --with-http_sub_module \
        --with-ipv6 \
        --with-debug \
        --with-sha1=/usr/include/openssl \
        --with-md5=/usr/include/openssl \
        --with-http_dav_module \
	--with-http_v2_module \
	--add-module=${MODULESDIR}/nginx-dav-ext-module \
	--add-module=${MODULESDIR}/nginx-upload-module \
	--add-module=${MODULESDIR}/nginx-upload-progress-module \
	--add-module=${MODULESDIR}/nginx-headers-more-module \
        --http-log-path=/var/log/nginx/access.log \
        --error-log-path=/var/log/nginx/error.log \
        --sbin-path=/usr/local/sbin/nginx && \
    make && make install

FROM alpine:3.11

COPY --from=build /usr/local/sbin/nginx /usr/local/sbin/

ADD nginx /etc/nginx/

# forward request and error logs to docker log collector
RUN apk update && apk add geoip pcre openssl libxml2 && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /var/log/nginx/ &&\
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    mkdir -p /var/lib/nginx &&  mkdir -p /etc/nginx/certs && mkdir -p /etc/nginx/conf.d/ && \
    mkdir -p /etc/nginx/htpasswd/ && \
    mkdir -p /etc/nginx/vhost.d/ && rm -rf /etc/nginx/sites-available/* && \
    mkdir -p /etc/nginx/dhparam/ && \
    mkdir -p /static_data

WORKDIR /etc/nginx

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]