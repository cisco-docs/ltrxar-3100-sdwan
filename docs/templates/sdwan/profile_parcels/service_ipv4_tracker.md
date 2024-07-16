# Service IPv4 Tracker Profile Parcel

Configure IPv4 Endpoint Tracker for IP, URL or TCP/UDP.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: service1
        ipv4_trackers:
          - name: static_route_tracker1
            threshold: 300
            interval: 20
            multiplier: 1
            endpoint_ip_variable: static_route_tracker1_ip
```
