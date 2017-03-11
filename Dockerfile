FROM ubuntu:trusty-20170119

ENV SKYPE_USER=skype

RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
  && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends 

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 7212620B \
 && echo "deb http://archive.canonical.com/ trusty partner" >> /etc/apt/sources.list \
 && dpkg --add-architecture i386 \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  pulseaudio:i386 skype:i386 sudo libv4l-0:i386 \
 && rm -rf /var/lib/apt/lists/*

COPY data/entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
