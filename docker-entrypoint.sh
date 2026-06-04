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

if [[ ! `gluster volume list 2>/dev/null | grep $GLUSTER_VOLUME_NAME` && "$CREATE_BRICK" == "true" ]];
then
    echo "Gluster volume $GLUSTER_VOLUME_NAME not found. Creating volume..."
    gluster volume create $GLUSTER_VOLUME_NAME $HOSTNAME:$GLUSTER_DATA_DIR force;
    gluster volume start $GLUSTER_VOLUME_NAME;
else 
    echo "Gluster volume $GLUSTER_VOLUME_NAME already exists. Skipping creation."
fi

if [[ "$MOUNT_BRICK" == "true" ]];
then
    mkdir -p "$GLUSTER_MOUNT_POINT";
    until gluster volume status "$GLUSTER_VOLUME_NAME" detail 2>/dev/null | grep -qE 'Online[[:space:]]*:[[:space:]]*Y'; do
        echo 'Waiting for volume to be ready before mounting...';
        sleep 2;
    done;
    mount -t glusterfs "$HOSTNAME:/$GLUSTER_VOLUME_NAME" "$GLUSTER_MOUNT_POINT";
else
    echo "Mounting of Gluster volume $GLUSTER_VOLUME_NAME is disabled. Skipping mount."
fi

tail -f /dev/null;
      
#exec "$@"