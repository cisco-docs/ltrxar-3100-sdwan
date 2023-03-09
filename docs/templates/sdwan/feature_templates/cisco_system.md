# Cisco System Feature Template

Configure basic system information, such as site ID, system IP, time zone, hostname, device groups, GPS coordinates, port hopping, and port offset.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  cedge_feature_templates:
    cisco_system:
      - name: FT-CEDGE-SYSTEM-01
        description: "Base Cisco System template"
        parameters:
          clock:
            timezone: DEVICE_VARIABLE;timezone
          description: DEVICE_VARIABLE;system_description
          gps-location:
            latitude: DEVICE_VARIABLE;system_latitude
            longitude: DEVICE_VARIABLE;system_longitude
          host-name: DEVICE_VARIABLE;system_hostname
          idle-timeout: 300
          location: DEVICE_VARIABLE;system_location
          on-demand:
            enable: DEVICE_VARIABLE;ondemand_tunnel_enable
            idle-timeout: DEVICE_VARIABLE;ondemand_tunnel_idle_timeout
          site-id: DEVICE_VARIABLE;site_id
          system-ip: DEVICE_VARIABLE;system_ip
```
