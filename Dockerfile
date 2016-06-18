FROM debian:jessie

MAINTAINER Michael Mitchell <mmitchel@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Microchip tools require i386 compatability libs
RUN dpkg --add-architecture i386 \
    && apt-get update -y \
    && apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386

RUN buildDeps='curl' \
    && apt-get install -y --no-install-recommends $buildDeps \
    && curl -fSL -A "Mozilla/4.0" -o /tmp/xc32.run "http://www.microchip.com/mplabxc32linux" \
    && chmod a+x /tmp/xc32.run \
    && /tmp/xc32.run --mode unattended --unattendedmodeui none \
        --netservername localhost --LicenseType FreeMode \
    && apt-get purge -y --auto-remove $buildDeps \
    && apt-get clean \
    && rm /tmp/xc32.run

ENV PATH /opt/microchip/xc32/v1.42/bin:$PATH
