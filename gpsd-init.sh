#!/bin/sh

/usr/sbin/gpsd -D5 -n -G ${GPS_DEVICE_NODE} &
exit
