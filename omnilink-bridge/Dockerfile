ARG BUILD_FROM=hassioaddons/debian-base:3.2.3
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base system
ARG BUILD_ARCH=amd64

RUN apt-get update && \
    apt-get install -y apt-transport-https dirmngr gnupg ca-certificates && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/debian stable-buster main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get update && \
    apt-get install -y mono-complete unzip

WORKDIR /app

ARG BUILD_VERSION

RUN curl -L -o OmniLinkBridge.zip https://github.com/excaliburpartners/OmniLinkBridge/releases/download/${BUILD_VERSION}/OmniLinkBridge.zip && \
    unzip OmniLinkBridge.zip && \
    rm -f OmniLinkBridge.zip

ARG BUILD_ARCH

LABEL \
    io.hass.name="OmniLink Bridge" \
    io.hass.description="MQTT bridge, web service API, time sync, and logging for HAI/Leviton OmniPro II controllers" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION}
    
COPY data/run.sh /
CMD [ "/run.sh" ]