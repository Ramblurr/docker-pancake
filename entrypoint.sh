#!/bin/sh
set -eu

version_greater() {
    [ "$(printf '%s\n' "$@" | sort -t '.' -n -k1,1 -k2,2 -k3,3 -k4,4 | head -n 1)" != "$1" ]
}

# return true if specified directory is empty
directory_empty() {
    [ -z "$(ls -A "$1/")" ]
}


installed_version="0.0.0.0"
if [ -f /var/www/html/system/pancake/VERSION ]; then
  installed_version="$(cat /var/www/html/system/pancake/VERSION)"
fi

image_version="$(cat /usr/src/pancake_4/pancake/system/pancake/VERSION)"

if version_greater "$installed_version" "$image_version"; then
  echo "Can't start Pancake because the version of the data ($installed_version) is higher than the docker image version ($image_version) and downgrading is not supported. Are you sure you have pulled the newest image version?"
  exit 1
fi

if version_greater "$image_version" "$installed_version"; then
  echo "Initializing Pancake $image_version ..."
  if [ "$installed_version" != "0.0.0.0" ]; then
    echo "Upgrading pancake from $installed_version ..."
  fi
  if [ "$(id -u)" = 0 ]; then
    rsync_options="-rlDog --chown www-data:root"
  else
    rsync_options="-rlD"
  fi
  rsync $rsync_options --delete --exclude-from=/upgrade.exclude /usr/src/pancake_4/pancake/ /var/www/html/

  for dir in uploads; do
    if [ ! -d "/var/www/html/$dir" ] || directory_empty "/var/www/html/$dir"; then
      rsync $rsync_options --include "/$dir/" --exclude '/*' /usr/src/pancake_4/pancake/ /var/www/html/
    fi
  done
  echo "Initializing finished"
  if [ "$installed_version" = "0.0.0.0" ]; then
    echo "New pancake instance"
  else
    echo "Upgrading pancake "
  fi
fi
exec "$@"
