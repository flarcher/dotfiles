#!/bin/bash

mount_box_usb_disk() {
  DISK_NAME="${1:-stockage}"
  USER_NAME="$(whoami)"
  USER_ID="$(id -u)"
  GROUP_ID="$(id -g)"
  MOUNT_DIR="/media/${USER_NAME}/${DISK_NAME}"
  sudo mkdir -p "${MOUNT_DIR}"
  sudo chown "${USER_ID}:${GROUP_ID}" "${MOUNT_DIR}"
  sudo mount -t cifs "//192.168.1.254/${DISK_NAME}" "${MOUNT_DIR}" -o guest,vers=1.0 -o "uid=${USER_ID}" -o "gid=${GROUP_ID}"
  echo "Disk ${DISK_NAME} has been mounted on ${MOUNT_DIR}"
}
