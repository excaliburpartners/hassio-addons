# OmniLink Bridge

## Test Build
```
    docker build \
        --build-arg BUILD_FROM="ghcr.io/home-assistant/armv7-base-debian:bookworm" \
        --build-arg BUILD_VERSION="1.1.19.2" \
        -t omnilink-bridge .
```