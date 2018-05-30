FROM ubuntu:latest

ENV SKYPE_USER=skype

RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends 

RUN apt-get update \
 && apt-get install -y wget sudo ca-certificates pulseaudio libv4l-0 \
 && wget --no-verbose https://go.skype.com/skypeforlinux-64.deb \
 && dpkg --force-depends -i skypeforlinux-64.deb \
 && apt-get install -fy \
 && rm skypeforlinux-64.deb \
 && rm -rf /var/lib/apt/lists/*

COPY data/entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh 

ENTRYPOINT ["/sbin/entrypoint.sh"]
