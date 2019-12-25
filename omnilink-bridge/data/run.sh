#!/usr/bin/env bashio

export CONTROLLER_ADDRESS=$(bashio::config 'controller_address')
export CONTROLLER_PORT=$(bashio::config 'controller_port')
export CONTROLLER_KEY1=$(bashio::config 'controller_key1')
export CONTROLLER_KEY2=$(bashio::config 'controller_key2')
export CONTROLLER_NAME=$(bashio::config 'controller_name')

if $(bashio::config 'time_sync') == "true"; then
    export TIME_SYNC=yes
    export TIME_INTERVAL=$(bashio::config 'time_interval')
    export TIME_DRIFT=$(bashio::config 'time_drift')
fi

if $(bashio::config 'webapi_enabled') == "true"; then
    export WEBAPI_ENABLED=yes
    export WEBAPI_PORT=$(bashio::config 'webapi_port')
fi

if $(bashio::config 'mqtt_enabled') == "true"; then
    export MQTT_ENABLED=yes
    export MQTT_SERVER=$(bashio::config 'mqtt_server')
    export MQTT_PORT=$(bashio::config 'mqtt_port')
    export MQTT_USERNAME=$(bashio::config 'mqtt_username')
    export MQTT_PASSWORD=$(bashio::config 'mqtt_password')
    export MQTT_PREFIX=$(bashio::config 'mqtt_prefix')
    export MQTT_DISCOVERY_PREFIX=$(bashio::config 'mqtt_discovery_prefix')

    if bashio::config.has_value 'mqtt_discovery_name_prefix'; then
        export MQTT_DISCOVERY_NAME_PREFIX=$(bashio::config 'mqtt_discovery_name_prefix')
    fi

    if bashio::config.has_value 'mqtt_discovery_ignore_zones'; then
        export MQTT_DISCOVERY_IGNORE_ZONES=$(bashio::config 'mqtt_discovery_ignore_zones')
    fi

    if bashio::config.has_value 'mqtt_discovery_ignore_units'; then
        export MQTT_DISCOVERY_IGNORE_UNITS=$(bashio::config 'mqtt_discovery_ignore_units')
    fi

    if bashio::config.has_value 'mqtt_discovery_override_zone'; then
        export MQTT_DISCOVERY_OVERRIDE_ZONE=$(bashio::config 'mqtt_discovery_override_zone')
    fi
fi

mono /app/OmniLinkBridge.exe -i -c /app/OmniLinkBridge.ini