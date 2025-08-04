ARG BUILD_FROM=homeassistant/aarch64-base-debian:bookworm
# -----------------------------
# Build Stage: Compile OmniLinkBridge
# -----------------------------
FROM debian:bookworm-slim AS build

# Install tools and mono from official repository
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gnupg dirmngr ca-certificates apt-transport-https curl git

# Add Mono GPG key and repo (only stable-buster exists)
RUN gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys \
        3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    gpg --batch --export --armor 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF > \
        /etc/apt/trusted.gpg.d/mono.gpg.asc && \
    echo "deb https://download.mono-project.com/repo/debian stable-buster main" > \
        /etc/apt/sources.list.d/mono-official-stable.list &&\
    apt-get update && \
    apt-get install -y --no-install-recommends \
        mono-complete msbuild nuget

# Download source code from GitHub using the version tag
ARG BUILD_VERSION
RUN major=`echo $BUILD_VERSION | cut -d. -f1` && \
    minor=`echo $BUILD_VERSION | cut -d. -f2` && \
    revision=`echo $BUILD_VERSION | cut -d. -f3` && \
    git clone --depth 1 -b $major.$minor.$revision https://github.com/jmantas/OmniLinkBridge.git /build

WORKDIR /build

# Restore dependencies and build project
RUN nuget restore /build/OmniLinkBridge.sln && \
    msbuild /build/OmniLinkBridge.sln /t:Build /p:Configuration=Release && \
    mv /build/OmniLinkBridge/bin/Release /app

# ------------------------------------------------
# Runtime Stage: Final Home Assistant add-on image
# ------------------------------------------------

FROM $BUILD_FROM AS runtime

# Copy root filesystem for Home Assistant add-on environment
COPY rootfs /

# Install Mono runtime from the official repository
RUN apt-get update && \
    apt-get install -y --no-install-recommends gnupg dirmngr ca-certificates apt-transport-https && \
    rm -rf /var/lib/apt/lists/* && \
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    gpg --batch --export --armor 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF > /etc/apt/trusted.gpg.d/mono.gpg.asc && \
    echo "deb https://download.mono-project.com/repo/debian stable-bookworm main" > \
         /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get update && \
    apt-get install -y mono-complete && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# Cleanup GPG tools
RUN gpgconf --kill all && \
    rm -rf "$GNUPGHOME" && \
    apt-get purge -y --auto-remove gnupg dirmngr

WORKDIR /app

COPY --from=build /app/OmniLinkBridge.ini /config/OmniLinkBridge.ini
COPY --from=build /app .
