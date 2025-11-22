# Transport IPv4 Tracker Feature

Configure IPv4 Tracker for IP, URL or DNS name.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to create an IPv4 endpoint IP tracker under transport profile with threshold, interval and multiplier specified as global value and endpoint ip configured as variable.

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
            tracker_name: tracker1
```

Example-2: This example demonstrates how to create an IPv4 endpoint API URL tracker under transport profile with tracker name and endpoint API URL configured as global value.

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      ipv4_trackers:
        - name: ipv4_api_tracker
          description: API URL Tracker
          endpoint_api_url: https://api.example.com
          tracker_name: transport_ipv4_api_tracker
```

Example-3: This example demonstrates how to create an IPv4 endpoint DNS tracker under transport profile with tracker name and endpoint DNS configured as global value.

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      ipv4_trackers:
        - name: ipv4_dns_tracker
          description: DNS Tracker
          endpoint_dns_name: example.com
          tracker_name: transport_ipv4_dns_tracker
```
