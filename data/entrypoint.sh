#!/bin/bash
[[ "$TRACE" ]] && set -x
set -e

USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-1000}

create_user() {
  # create group with USER_GID
  if ! getent group ${SKYPE_USER} >/dev/null; then
    groupadd -f -g ${USER_GID} ${SKYPE_USER} >/dev/null 2>&1
  fi

  # create user with USER_UID
  if ! getent passwd ${SKYPE_USER} >/dev/null; then
    adduser --disabled-login --uid ${USER_UID} --gid ${USER_GID} \
      --gecos 'Skype' ${SKYPE_USER} >/dev/null 2>&1
  fi
  chown ${SKYPE_USER}:${SKYPE_USER} -R /home/${SKYPE_USER}
}

grant_access_to_video_devices() {
  for device in /dev/video*
  do
    if [[ -c $device ]]; then
      VIDEO_GID=$(stat -c %g $device)
      VIDEO_GROUP=$(stat -c %G $device)
      if [[ ${VIDEO_GROUP} == "UNKNOWN" ]]; then
        VIDEO_GROUP=skypevideo
        groupadd -g ${VIDEO_GID} ${VIDEO_GROUP}
      fi
      usermod -a -G ${VIDEO_GROUP} ${SKYPE_USER}
      break
    fi
  done
}

launch_skype() {
  cd /home/${SKYPE_USER}
  exec sudo -HEu ${SKYPE_USER} PULSE_SERVER=/run/pulse/native QT_GRAPHICSSYSTEM="native" /usr/share/skypeforlinux/skypeforlinux --executed-from="$(pwd)" --pid="$$"
}

case "$1" in
  skype)
    echo "Skype"
    create_user
    grant_access_to_video_devices
    launch_skype
    ;;
  *)
    echo "Command"
    exec $@
    ;;
esac
