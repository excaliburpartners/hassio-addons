ARG BUILD_FROM
FROM debian:bookworm AS build

RUN apt update && apt install -y dirmngr ca-certificates gnupg \
  && gpg --homedir /tmp --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/mono-official-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
  && chmod +r /usr/share/keyrings/mono-official-archive-keyring.gpg \
  && echo "deb [signed-by=/usr/share/keyrings/mono-official-archive-keyring.gpg] https://download.mono-project.com/repo/debian stable-buster main" | tee /etc/apt/sources.list.d/mono-official-stable.list \
  && apt update && apt install -y mono-complete nuget git \
  && rm -rf /var/lib/apt/lists/* /tmp/*

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

RUN apt update && apt install -y dirmngr ca-certificates gnupg \
  && gpg --homedir /tmp --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/mono-official-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
  && chmod +r /usr/share/keyrings/mono-official-archive-keyring.gpg \
  && echo "deb [signed-by=/usr/share/keyrings/mono-official-archive-keyring.gpg] https://download.mono-project.com/repo/debian stable-buster main" | tee /etc/apt/sources.list.d/mono-official-stable.list \
  && apt update && apt install -y mono-complete \
  && rm -rf /var/lib/apt/lists/* /tmp/*

WORKDIR /app

COPY --from=build /app/OmniLinkBridge.ini /config/OmniLinkBridge.ini
COPY --from=build /app .
