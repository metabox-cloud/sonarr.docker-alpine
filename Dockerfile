#metaBox Sonarr: V2
#https://www.github.com/metabox-cloud
FROM metaboxcloud/baseimage.alpine:latest
LABEL maintainer="metaBox <contact@metabox.cloud>"
LABEL build="Sonarr - v2 :: Alpine"

ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TERM='xterm' \
    VERSION='develop'

COPY root/ /

RUN echo http://dl-4.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
  apk -U upgrade && \
  apk -U add \
    libmediainfo \
    ca-certificates \
    mono \
    && \
  apk del make gcc g++ && \
  rm -rf /tmp/src && \
  rm -rf /var/cache/apk/*

RUN \
  mkdir -p /opt/NzbDrone && \
  wget http://download.sonarr.tv/v2/$VERSION/mono/NzbDrone.$VERSION.tar.gz -O NzbDrone.tgz && \
  tar xzvf NzbDrone.tgz && \
  rm NzbDrone.tgz \
   echo "**** cleanup ****" && \
 rm -rf \
        /tmp/* \
        /var/tmp/* \
    /cleanup

VOLUME  ["/config"]
VOLUME  ["/mb"]

EXPOSE 8989

ENTRYPOINT ["/init"]