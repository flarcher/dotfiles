#!/bin/bash

function monitor-id {
  xrandr --listmonitors \
    | grep --color=never -e "^ ${1:-0}" \
    | tr -s ' ' | cut -d' ' -f5
}

MONITOR_FIRST="$(monitor-id '0')"

function monitor-on-left {
  local monitor_second="$(monitor-id '1')"
  xrandr --output "${monitor_second}" --auto --left-of "${MONITOR_FIRST}"
}

function monitor-on-right {
  local monitor_second="$(monitor-id '1')"
  xrandr --output "${monitor_second}" --auto --right-of "${MONITOR_FIRST}"
}

