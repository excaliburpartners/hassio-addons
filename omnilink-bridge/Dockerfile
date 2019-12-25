ARG BUILD_FROM
FROM $BUILD_FROM

WORKDIR /app

ARG BUILD_VERSION

RUN apk add --no-cache mono --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
    apk add --no-cache --virtual=.build-dependencies ca-certificates && \
    cert-sync /etc/ssl/certs/ca-certificates.crt && \
    apk del .build-dependencies

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