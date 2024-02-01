# System Feature Template

Configure basic system information, such as site ID, system IP, time zone, hostname, device groups, GPS coordinates, port hopping, and port offset.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  edge_feature_templates:
    system_templates:
      - name: FT-CEDGE-SYSTEM-01
        description: "Base Cisco System template"
        timezone: Europe/Warsaw
        system_description_variable: system_description
        latitude_variable: system_latitude
        longitude_variable: system_longitude
        hostname_variable: system_hostname
        idle_timeout: 300
        location_variable: system_location
        on_demand_tunnel: true
        on_demand_tunnel_idle_timeout: 3000
        site_id_variable: site_id
        system_ip_variable: system_ip
        endpoint_trackers:
          - name: static_route_tracker
            threshold: 300
            interval: 20
            multiplier: 1
            type: static-route
            endpoint_ip_variable: static_route_tracker_ip
```
