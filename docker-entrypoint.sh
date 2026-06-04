#!/bin/bash
set -e

if [ -z "$(ls -A /etc/glusterfs 2>/dev/null)" ]; then
    echo "Seeding /etc/glusterfs with default configs..."
    chmod 755 /etc/glusterfs
    cp -a /etc/glusterfs.defaults/. /etc/glusterfs/
fi

sed -i "s/option max-port.*$/option max-port $GLUSTER_MAX_PORT/g" /etc/glusterfs/glusterd.vol

exec /usr/sbin/glusterd \
    --pid-file /var/run/glusterd.pid \
    --no-daemon \
    --log-file /dev/stdout \
    "$@"