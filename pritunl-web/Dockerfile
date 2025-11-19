FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update && apt-get install -y curl gnupg ca-certificates iptables iproute2 vim \
    && curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor --yes \
    && curl -fsSL https://swupdate.openvpn.net/repos/repo-public.gpg | gpg -o /usr/share/keyrings/openvpn-repo.gpg --dearmor --yes \
    && curl -fsSL https://raw.githubusercontent.com/pritunl/pgp/master/pritunl_repo_pub.asc | gpg -o /usr/share/keyrings/pritunl.gpg --dearmor --yes \
    && echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" > /etc/apt/sources.list.d/mongodb-org.list \
    && echo "deb [ signed-by=/usr/share/keyrings/openvpn-repo.gpg ] https://build.openvpn.net/debian/openvpn/stable noble main" > /etc/apt/sources.list.d/openvpn.list \
    && echo "deb [ signed-by=/usr/share/keyrings/pritunl.gpg ] https://repo.pritunl.com/stable/apt noble main" > /etc/apt/sources.list.d/pritunl.list \
    && apt-get update \
    && apt-get install -y pritunl openvpn mongodb-org wireguard wireguard-tools \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
COPY setup.py /usr/local/bin/setup.py
RUN chmod +x /entrypoint.sh /usr/local/bin/setup.py

EXPOSE 80 443 1194/udp 1194/tcp 9700

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/bin/pritunl", "start"]
