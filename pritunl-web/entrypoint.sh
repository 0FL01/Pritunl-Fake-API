#!/bin/bash
set -e

: "${PRITUNL_MONGODB_URI:=mongodb://127.0.0.1:27017/pritunl}"
: "${PRITUNL_BIND_ADDR:=0.0.0.0}"
: "${PRITUNL_PORT:=443}"
: "${PRITUNL_LOG_PATH:=/var/log/pritunl.log}"
: "${PRITUNL_DEBUG:=false}"

cat <<EOF > /etc/pritunl.conf
{
    "static_cache": true,
    "debug": $PRITUNL_DEBUG,
    "port": $PRITUNL_PORT,
    "bind_addr": "$PRITUNL_BIND_ADDR",
    "mongodb_uri": "$PRITUNL_MONGODB_URI",
    "log_path": "$PRITUNL_LOG_PATH",
    "www_path": "/usr/share/pritunl/www",
    "local_address_interface": "auto"
}
EOF

PY_SITE_PACKAGES=$(find /usr/lib/pritunl/usr/lib/ -name site-packages | head -n 1)

if [ -d "$PY_SITE_PACKAGES" ]; then
    echo "Applying SSL bypass patches to $PY_SITE_PACKAGES..."
    
    sed -i 's/self.verify = True/self.verify = False/g' "$PY_SITE_PACKAGES/requests/sessions.py"
    
    if grep -q "ssl._create_default_https_context" "$PY_SITE_PACKAGES/pritunl/__init__.py"; then
        echo "SSL patch already applied."
    else
        sed -i '1s/^/import ssl; ssl._create_default_https_context = ssl._create_unverified_context\n/' "$PY_SITE_PACKAGES/pritunl/__init__.py"
    fi
fi

if [ ! -f "/etc/pritunl_patched" ]; then
    if [ -n "$PRITUNL_API" ]; then
        echo "Applying custom PRITUNL_API: $PRITUNL_API"
        python3 /usr/local/bin/setup.py --install "$PRITUNL_API"
    else
        echo "Applying default PRITUNL_API (simonmicro)"
        python3 /usr/local/bin/setup.py --install
    fi
    touch /etc/pritunl_patched
fi

exec "$@"
