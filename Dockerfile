#metaBox Sonarr: V3 Preview
#https://www.github.com/metabox-cloud
FROM metaboxcloud/baseimage.alpine:latest
LABEL maintainer="metaBox <contact@metabox.cloud>"
LABEL build="Sonarr - v3 (Preview) :: Alpine"

ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TERM='xterm' \
    VERSION='phantom-develop'

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
  cd /opt && \ 
  wget "https://services.sonarr.tv/v1/download/$VERSION/latest?version=3&os=linux" -O NzbDrone.tgz && \
tar xf \
        /tmp/NzbDrone.tgz -C \
        /opt/NzbDrone --strip-components=1 && \
 echo "UpdateMethod=docker\nBranch=${SONARR_BRANCH}\nPackageVersion=${VERSION}\nPackageAuthor=metaBox.cloud" > /opt/NzbDrone/package_info && \
 rm -rf /opt/NzbDrone/Sonarr.Update && \
   echo "**** cleanup ****" && \
 rm -rf \
        /tmp/* \
        /var/tmp/* \
    /cleanup

VOLUME  ["/config"]
VOLUME  ["/mb"]

EXPOSE 8989

ENTRYPOINT ["/init"]
