FROM ubuntu:24.04

RUN apt-get update && apt-get upgrade -yf && apt-get install -yf glusterfs-server && \
    cp -a /etc/glusterfs /etc/glusterfs.defaults

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["--log-level=INFO"]