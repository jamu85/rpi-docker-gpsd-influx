#FROM linarotechnologies/alpine:edge
FROM alpine:latest

ENV PYTHONUNBUFFERED=1

RUN apk add --update --no-cache gpsd htop
RUN apk add --update --no-cache python3 py3-pip && ln -sf python3 /usr/bin/python

RUN pip install --upgrade pip && \
    pip install --no-cache-dir gps influxdb

EXPOSE 2947

COPY influx-script/influx-connector.py /opt/influx-connector.py
RUN ["chmod", "a+x", "/opt/influx-connector.py"]

COPY gpsd-init.sh /opt/gpsd-init.sh
RUN ["chmod", "a+x", "/opt/gpsd-init.sh"]

#CMD ["/opt/gpsd-init.sh"]

ENTRYPOINT ["htop"]

#ENTRYPOINT ["/opt/influx-connector.py"]
