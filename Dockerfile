FROM ubuntu:18.04

MAINTAINER Manish Kumar

# Install OpenJDK-8
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get clean;

# creating direcotry for installation
RUN mkdir -p /software/reboot-utils/

# copying util file
COPY reboot-utils-0.2.2.3.tar /tmp
RUN tar xvf tmp/reboot-utils-0.2.2.3.tar -C /software/reboot-utils/

# copying exomiser jar file
COPY exomiser-cli-12.1.0 /software/reboot-utils/exomiser-cli-12.1.0
COPY env.sh /env.sh

CMD ["/bin/sh", "/env.sh"]

