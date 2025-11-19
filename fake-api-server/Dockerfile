FROM php:8.4-fpm-alpine

RUN apk add --no-cache nginx supervisor openssl

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/self.key \
    -out /etc/nginx/ssl/self.crt \
    -subj "/C=DE/ST=Nizhnekamsk/L=Nizhnekamsk/O=MGE/OU=IT/CN=ass-peak"

COPY www /var/www/html

COPY nginx.conf /etc/nginx/http.d/default.conf

COPY supervisord.conf /etc/supervisord.conf

EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
