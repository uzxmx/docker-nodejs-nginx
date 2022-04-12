FROM node:8.14.0-alpine

RUN apk add --no-cache gcc libc-dev make pcre-dev zlib-dev openssl-dev \
  && tmpdir="$(mktemp -d)" \
  && cd ${tmpdir} \
  && wget 'http://nginx.org/download/nginx-1.19.0.tar.gz' \
  && tar zxf nginx-1.19.0.tar.gz \
  && wget 'https://github.com/openresty/headers-more-nginx-module/archive/master.zip' \
  && unzip master.zip \
  && cd nginx-1.19.0 \
  && ./configure --prefix=/usr/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf \
    --add-module=../headers-more-nginx-module-master --with-http_ssl_module \
    --with-http_gzip_static_module \
  && make && make install \
  && mkdir -p /etc/nginx/conf.d \
  && rm -rf ${tmpdir} \
  && apk del gcc make

COPY nginx.conf /etc/nginx
COPY html/*.html /usr/nginx/html/
