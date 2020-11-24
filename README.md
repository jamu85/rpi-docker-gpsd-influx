[![Build Status](https://cloud.drone.io/api/badges/jamu85/rpi-docker-gpsd-influx/status.svg)](https://cloud.drone.io/jamu85/rpi-docker-gpsd-influx)

# rpi-docker-gpsd-influx

## Introduction

This image tracks the location of my camper van and pushes the values into a [influxdb](https://www.influxdata.com) for further data analysis with [grafana](https://grafana.com). The work is heavily based on the project [gpsd-influx](https://github.com/mzac/gpsd-influx). The image is compiled for arm64 to run on a Raspberry 4 but should also run on any other platform if you build the image locally.

## What it does

The container is taking the data from a serial gps device and exposes and api on a port on localhost. This port can be exposed so that the gps data can also be used for other scenarios. Additional, there is a python script that implements a client for this api and pushes the data to an influxdb instance.

## Environment variables

The container expects environment variables which are defaulting to the following values. Make sure to change the values according to your setup.

```
INFLUX_HOST=influxdb
INFLUX_PORT=8086
INFLUX_USER=user
INFLUX_PASS=secret
INFLUX_DB=database
UPDATE_INTERVAL=10
GPS_DEVICE_NODE=/dev/ttyACM0
GPSD_PORT=2947
GPSD_HOST=localhost
```

## Use it

`
$ docker pull jamu85/rpi-docker-gpsd-influx:latest
`

`
$ docker network create proxy
`

`
$ docker run -it --device=/dev/ttyACM0 --env GPS_DEVICE_NODE='/dev/ttyACM0' --env INFLUX_HOST='influxdb' --env INFLUX_PORT=8086 --env INFLUX_USER=user --env INFLUX_PASS=secret --env INFLUX_DB=database --env UPDATE_INTERVAL=10 --env GPSD_PORT=2947 --env GPSD_HOST=localhost  --network=proxy jamu85/rpi-docker-gpsd-influx:latest
`
Make sure that your influxdb container is running in the same docker network for name resolving

To make a local build run

`
docker build . -t rpi-docker-gpsd-influx:dev
`

## docker-compose

````
version: '3.7'

services:
  gps-connector:
    image: jamu85/rpi-docker-gpsd-influx:latest
    container_name: gps-connector
    devices:
      - ${GPS_DEVICE_NODE}
    environment:
      - INFLUX_HOST=$INFLUX_HOST
      - INFLUX_PORT=$INFLUX_PORT
      - INFLUX_USER=$INFLUX_USER
      - INFLUX_PASS=$INFLUX_PASS
      - INFLUX_DB=$INFLUX_DB
      - GPS_DEVICE_NODE=$GPS_DEVICE_NODE
      - UPDATE_INTERVAL=$UPDATE_INTERVAL
      - GPSD_PORT=$GPSD_PORT
      - GPSD_HOST=$GPSD_HOST
    networks:
      - proxy

networks:
  proxy:
    external: true
````

Make a .env file and change the settings according to your setup.

`
$ mv .env.example .env
`

`
$ docker-compose up -d
`

## Todo

- [ ] Make debug output configurable
- [ ] Fix bug with gpsd_track to get direction
- [ ] Add Grafana configs

## Contribute

Clone -> Branch -> Pull Request

## License

Apache-2.0