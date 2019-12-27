#!/usr/bin/env bashio
CONFIG_PATH=/data/options.json

jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' $CONFIG_PATH > /app/OmniLinkBridge.ini

mono /app/OmniLinkBridge.exe -i -c /app/OmniLinkBridge.ini