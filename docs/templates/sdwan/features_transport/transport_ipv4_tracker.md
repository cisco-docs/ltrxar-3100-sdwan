# Transport IPv4 Tracker Feature

Configure IPv4 Tracker for IP, URL or DNS name.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: transport1
        ipv4_trackers:
          - name: tracker1
            threshold: 300
            interval: 20
            multiplier: 1
            endpoint_ip_variable: tracker1_ip
```
