FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV PRITUNL_API=127.0.0.1:63134

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl gnupg ca-certificates iptables iproute2 vim software-properties-common \
    && curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor --yes \
    && curl -fsSL https://swupdate.openvpn.net/repos/repo-public.gpg | gpg -o /usr/share/keyrings/openvpn-repo.gpg --dearmor --yes \
    && curl -fsSL https://raw.githubusercontent.com/pritunl/pgp/master/pritunl_repo_pub.asc | gpg -o /usr/share/keyrings/pritunl.gpg --dearmor --yes \
    && echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" > /etc/apt/sources.list.d/mongodb-org.list \
    && echo "deb [ signed-by=/usr/share/keyrings/openvpn-repo.gpg ] https://build.openvpn.net/debian/openvpn/stable noble main" > /etc/apt/sources.list.d/openvpn.list \
    && echo "deb [ signed-by=/usr/share/keyrings/pritunl.gpg ] https://repo.pritunl.com/stable/apt noble main" > /etc/apt/sources.list.d/pritunl.list \
    && add-apt-repository ppa:ondrej/php -y \
    && apt-get update \
    && apt-get install -y --no-install-recommends pritunl openvpn mongodb-org wireguard wireguard-tools \
       nginx supervisor openssl php8.4-fpm \
    && apt-get purge -y --auto-remove gnupg \
    && dpkg --purge --force-depends mongodb-org-server || true \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* /tmp/* /var/tmp/*

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/self.key \
    -out /etc/nginx/ssl/self.crt \
    -subj "/C=RU/ST=Blackholl/L=Nizhnekamsk/O=ass-peak/OU=API/CN=ass-peak.com"

COPY entrypoint.sh /entrypoint.sh
COPY setup.py /usr/local/bin/setup.py
COPY api-nginx.conf /etc/nginx/sites-available/api
COPY supervisord.conf /etc/supervisor/conf.d/pritunl.conf
COPY php-fpm-www.conf /etc/php/8.4/fpm/pool.d/www.conf
COPY www /var/www/html

RUN chmod +x /entrypoint.sh /usr/local/bin/setup.py \
    && rm -f /etc/nginx/sites-enabled/default \
    && ln -s /etc/nginx/sites-available/api /etc/nginx/sites-enabled/api \
    && chown -R www-data:www-data /var/www/html \
    && rm -rf /root/.cache \
    && find / -name "__pycache__" -type d -exec rm -rf {} +

EXPOSE 80 443 1194/udp 1194/tcp 9700

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]