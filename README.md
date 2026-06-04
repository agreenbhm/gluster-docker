# gluster-docker

Dockerized GlusterFS server based on Ubuntu 24.04. Automatically seeds default GlusterFS configuration files into a host-mounted volume on first run.

## Build

```bash
docker build -t agreenbhm/gluster:ubuntu2404 .
```

## Run
Make sure to add an additional mount if you want to store your brick data on persistent storage.  `/etc/glusterfs` and `/var/lib/glusterd` must be mounted externally if you want to persist your configuration and brick/volume list.

```bash
docker run -d --privileged \
  -p 24007:24007 \
  -p 24008:24008 \
  -p 49152:49152 \
  -p 49153:49153 \
  -p 49154:49154 \
  -p 49155:49155 \
  -p 49156:49156 \
  -p 24007:24007/udp \
  -p 24008:24008/udp \
  -p 49152:49152/udp \
  -p 49153:49153/udp \
  -p 49154:49154/udp \
  -p 49155:49155/udp \
  -p 49156:49156/udp \
  -e GLUSTER_MAX_PORT=49156 \
  -v $(pwd)/data/etc:/etc/glusterfs \
  -v $(pwd)/data/var:/var/lib/glusterd \
  --name gluster \
  agreenbhm/gluster:ubuntu2404
```

## Docker Compose

```yaml
services:
  gluster:
    image: agreenbhm/gluster:ubuntu2404
    container_name: gluster
    privileged: true
    environment:
      - GLUSTER_MAX_PORT=49156
    ports:
      - "24007:24007"
      - "24008:24008"
      - "49152:49152"
      - "49153:49153"
      - "49154:49154"
      - "49155:49155"
      - "49156:49156"
      - "24007:24007/udp"
      - "24008:24008/udp"
      - "49152:49152/udp"
      - "49153:49153/udp"
      - "49154:49154/udp"
      - "49155:49155/udp"
      - "49156:49156/udp"
    volumes:
      - ./data/etc:/etc/glusterfs
      - ./data/var:/var/lib/glusterd
    restart: unless-stopped
```