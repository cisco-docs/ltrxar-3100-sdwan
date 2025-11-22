# System Basic Feature

Configure basic system information, such as site ID, system IP, time zone, hostname, device groups, GPS coordinates, port hopping, and port offset.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    system_profiles:
      - name: system1
        basic:
          name: basic
          timezone: Europe/Warsaw
          system_description_variable: system_description
          latitude_variable: system_latitude
          longitude_variable: system_longitude
          idle_timeout: 300
          location_variable: system_location
          on_demand_tunnel: true
          on_demand_tunnel_idle_timeout: 3000
```
