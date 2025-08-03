ARG BUILD_FROM
FROM mono:latest AS build

RUN apt-get update && \
  apt-get install -y git

ARG BUILD_VERSION
RUN major=`echo $BUILD_VERSION | cut -d. -f1` \
    && minor=`echo $BUILD_VERSION | cut -d. -f2` \
    && revision=`echo $BUILD_VERSION | cut -d. -f3` \
    && git clone --depth 1 -b $major.$minor.$revision https://github.com/excaliburpartners/OmniLinkBridge.git /build

WORKDIR /build

RUN nuget restore /build/OmniLinkBridge.sln
RUN msbuild /build/OmniLinkBridge.sln /t:Build /p:Configuration=Release
RUN mv /build/OmniLinkBridge/bin/Release /app

FROM $BUILD_FROM AS runtime

# Copy root filesystem
COPY rootfs /

RUN apt-get update \
  && apt-get install -y --no-install-recommends gnupg dirmngr ca-certificates \
  && rm -rf /var/lib/apt/lists/* \
  && export GNUPGHOME="$(mktemp -d)" \
  && gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
  && gpg --batch --export --armor 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF > /etc/apt/trusted.gpg.d/mono.gpg.asc \
  && gpgconf --kill all \
  && rm -rf "$GNUPGHOME" \
  && apt-key list | grep Xamarin \
  && apt-get purge -y --auto-remove gnupg dirmngr

RUN echo "deb https://download.mono-project.com/repo/debian stable-bookworm main" > /etc/apt/sources.list.d/mono-official-stable.list \
  && apt-get update \
  && apt-get install -y mono-complete \
  && rm -rf /var/lib/apt/lists/* /tmp/*

WORKDIR /app

COPY --from=build /app/OmniLinkBridge.ini /config/OmniLinkBridge.ini
COPY --from=build /app .
