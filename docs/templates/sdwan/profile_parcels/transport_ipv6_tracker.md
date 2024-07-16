# Transport IPv6 Tracker Profile Parcel

Configure IPv6 Tracker for IP, URL or DNS name.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: transport1
        ipv6_trackers:
          - name: tracker1
            threshold: 300
            interval: 20
            multiplier: 1
            endpoint_ip_variable: tracker1_ip
```
