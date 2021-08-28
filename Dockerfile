FROM alpine:3.14.2
ENV container docker
LABEL maintainer="Amin Vakil <info@aminvakil.com>"

RUN apk add --no-cache nfs-utils==2.5.3-r0 bash=5.1.4-r0 && \
    mkdir -p /var/lib/nfs/rpc_pipefs /var/lib/nfs/v4recovery && \
    echo "rpc_pipefs    /var/lib/nfs/rpc_pipefs rpc_pipefs      defaults        0       0" >> /etc/fstab && \
    echo "nfsd  /proc/fs/nfsd   nfsd    defaults        0       0" >> /etc/fstab

COPY exports /etc/
COPY nfsd.sh /usr/bin/nfsd.sh

RUN chmod +x /usr/bin/nfsd.sh

ENTRYPOINT ["/usr/bin/nfsd.sh"]
