FROM ubuntu:24.04

RUN apt-get update && apt-get upgrade -yf && apt-get install -yf glusterfs-server

RUN cp -a /etc/glusterfs /etc/glusterfs.defaults
RUN cp -a /var/lib/glusterd /var/lib/glusterd.defaults

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]