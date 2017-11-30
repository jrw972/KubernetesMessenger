FROM objectcomputing/opendds:release-DDS-3.12

COPY publisher /opt/workspace/publisher
COPY subscriber /opt/workspace/subscriber
COPY make-config.sh /opt/workspace/make-config.sh
COPY config.ini.in /opt/workspace/config.ini.in
