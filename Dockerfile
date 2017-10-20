FROM alpine:3.5

RUN apk update && \
  apk add \
    curl \
    ca-certificates \
    git \
    openssh \
    curl \
    perl && \
  rm -rf /var/cache/apk/*

RUN lfs_version=2.3.4 && \
    lfs_sha256=6755e109a85ffd9a03aacc629ea4ab1cbb8e7d83e41bd1880bf44b41927f4cfe && \
    mkdir /tmp/${lfs_version} && \
    curl -o /tmp/lfs.tgz -L "https://github.com/git-lfs/git-lfs/releases/download/v${lfs_version}/git-lfs-linux-amd64-${lfs_version}.tar.gz" \
    && [ "$(sha256sum /tmp/lfs.tgz | awk '{print $1'})" = ${lfs_sha256} ]  && echo "sha256 match on lfs release" || exit 1 \
    && tar xvzf /tmp/lfs.tgz -C /tmp \
    && mv "/tmp/git-lfs-${lfs_version}/git-lfs" /bin/git-lfs \
    && git lfs install \
    && unset lfs_version lfs_sha256 \
    && rm -r /tmp/${lfs_version}

ADD drone-git /bin/
ENTRYPOINT ["/bin/drone-git"]
