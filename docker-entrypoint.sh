#!/bin/bash
set -e

if [ -z "$(ls -A /etc/glusterfs 2>/dev/null)" ]; then
    echo "Seeding /etc/glusterfs with default configs..."
    chmod 755 /etc/glusterfs
    cp -a /etc/glusterfs.defaults/. /etc/glusterfs/
fi

if [ -z "$(ls -A /var/lib/glusterd 2>/dev/null)" ]; then
    echo "Seeding /var/lib/glusterd with default configs..."
    chmod 755 /var/lib/glusterd
    cp -a /var/lib/glusterd.defaults/. /var/lib/glusterd/
fi

sed -i "s/option max-port.*$/option max-port $GLUSTER_MAX_PORT/g" /etc/glusterfs/glusterd.vol

if [ "$ENV" = "DEV" ]; then
    echo "Starting in development mode..."
    /etc/init.d/ssh start
fi

/usr/sbin/glusterd --pid-file /var/run/glusterd.pid --log-file /dev/stdout --log-level INFO

exec "$@"