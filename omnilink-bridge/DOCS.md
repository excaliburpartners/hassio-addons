# Home Assistant Add-on: OmniLink Bridge

## Configuration
**Note**: _Remember to restart the add-on when the configuration is changed._

### HAI / Leviton Omni Controller
- `controller_address` hostname or IP address
- `controller_port` defaults to `4369`
- `controller_key1`
- `controller_key2`
- `controller_name` defaults to `OmniLinkBridge`, used in notifications

### Controller Time Sync
- `time_sync` enable time synchronization
- `time_interval` defaults to `60`, interval in minutes to check controller time
- `time_drift` defaults to `10`, drift in seconds to allow before an adjustment is made

### MQTT
Can be used for integration with Home Assistant. If you have multiple Omni Controllers you will want to change the `mqtt_prefix` and `mqtt_discovery_name_prefix` to prevent collisions.
- `mqtt_enabled` enable MQTT
- `mqtt_server` hostname or IP address
- `mqtt_port`defaults to `1883`
- `mqtt_username`
- `mqtt_password`
- `mqtt_prefix` defaults to `omnilink`, prefix for MQTT state / command topics
- `mqtt_discovery_prefix` defaults to `homeassistant`, prefix for Home Assistant discovery
- `mqtt_discovery_name_prefix` prefix for Home Assistant entity names
- `mqtt_discovery_ignore_zones` range of numbers `1,2,3,5-10`
  - skip publishing Home Assistant discovery topics for zones/units
- `mqtt_discovery_ignore_units` range of numbers `1,2,3,5-10`
  - skip publishing Home Assistant discovery topics for zones/units
- `mqtt_discovery_area_code_required`  range of numbers `1,2,3,5-10`
  - require Home Assistant to prompt for user code when arming/disarming area
- `mqtt_discovery_override_zone`
  - override the zone Home Assistant binary sensor device_class
  - formatted as `id=5;device_class=garage_door`
  - multiple entries must be separated with a comma
  - `device_class` must be `battery`, `cold`, `door`, `garage_door`, `gas`, `heat`, `moisture`, `motion`, `problem`, `safety`, `smoke`, or `window`
- `mqtt_discovery_override_unit`
  - formatted as `id=1;type=switch,id=395;type=number`
  - multiple entries must be separated with a comma
  - `type` must be
    - units (LTe 1-32, IIe 1-64, Pro 1-256) `light` or `switch`, defaults to `light`
    - flags (LTe 41-88, IIe 73-128, Pro 393-511) `switch` or `number`, defaults to `switch`
- `mqtt_discovery_button_type`
  - publish buttons as this Home Assistant device type
  - must be `button` (recommended) or `switch` (default, previous behavior)
- `mqtt_audio_local_mute`
  - handle mute locally by setting volume to 0 and restoring to previous value
- `mqtt_audio_volume_media_player`
  - change audio volume scaling for Home Assistant media player
  - `true` 0.00-1.00, `false` 0-100 (default, previous behavior)

### Web Service
Can be used for integration with Samsung SmartThings.
- `webapi_enabled` enable web service
- `webapi_port` defaults to `8000`
- `webapi_override_zone`
  - formatted as `id=20;device_type=motion`
  - multiple entries must be separated with a comma
  - `device_type` must be `contact`, `motion`, `water`, `smoke`, or `co`

### Logging
- `verbose_unhandled` enable unsupported event logging
- `verbose_event`enable system event logging
- `verbose_area` enable area logging
- `verbose_zone` enable zone logging
- `verbose_thermostat_timer` enable thermostat timer logging
- `verbose_thermostat` enable thermostat logging
- `verbose_unit` enable unit logging
- `verbose_message` enable console message logging
- `verbose_lock` enable lock logging
- `verbose_audio` enable audio logging

### Notifications
- `notify_area` enable for area status changes
  - always sent for area alarms and critical system events
- `notify_message` enable for console messages

#### Email Notifications
- `mail_server` hostname or IP address
- `mail_tls` enable SSL
- `mail_port` defaults to `25`, when TLS is enabled the port is usually 587
- `mail_username` optional, required for authenticated mail
- `mail_password` optional, required for authenticated mail
- `mail_from`
- `mail_to`
  - multiple entries must be separated with a comma

#### Prowl Notifications
Register for API key at http://www.prowlapp.com
- `prowl_key`
  - multiple entries must be separated with a comma

#### Pushover Notifications
Register for API token at http://www.pushover.net
- `pushover_token`
- `pushover_user`
  - multiple entries must be separated with a comma
  
### Support
- `support_send_logs_to_developer`
  - sends logs to developer ONLY USE WHEN ASKED

### Universal Media Player
The [Universal media player](https://www.home-assistant.io/integrations/universal/) can be linked to an audio zone by adding the below to the Home Assistant config. This requires `mqtt_audio_volume_media_player: true`. Substitute `omnilink_AUDIOZONE` with the name of the audio zone entities.

```
media_player:
  platform: universal
  name: Audio Zone
  commands:
    turn_on:
      service: switch.turn_on
      target:
        entity_id: switch.omnilink_AUDIOZONE
    turn_off:
      service: switch.turn_off
      target:
        entity_id: switch.omnilink_AUDIOZONE
    volume_up:
      service: number.set_value
      target:
        entity_id: number.omnilink_AUDIOZONE_volume
      data:
        value: "{{ states('number.omnilink_AUDIOZONE_volume') | float + 0.01 }}"
    volume_down:
      service: number.set_value
      target:
        entity_id: number.omnilink_AUDIOZONE_volume
      data:
        value: "{{ states('number.omnilink_AUDIOZONE_volume') | float - 0.01 }}"
    volume_mute:
      service: switch.toggle
      target:
        entity_id: switch.omnilink_AUDIOZONE_mute
    select_source:
      service: select.select_option
      target:
        entity_id: select.omnilink_AUDIOZONE_source
      data:
        option: "{{ source }}"
    volume_set:
      service: number.set_value
      target:
        entity_id: number.omnilink_AUDIOZONE_volume
      data:
        value: "{{ volume_level }}"

  attributes:
    state: switch.omnilink_AUDIOZONE
    is_volume_muted: switch.omnilink_AUDIOZONE_mute
    volume_level: number.omnilink_AUDIOZONE_volume
    source: select.omnilink_AUDIOZONE_source
    source_list: select.omnilink_AUDIOZONE_source|options
```