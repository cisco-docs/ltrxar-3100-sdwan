# Transport IPv6 Tracker Feature

Configure IPv6 Tracker for IP, URL or DNS name.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to create an IPv6 endpoint IP tracker under transport profile with threshold, interval and multiplier specified as global value and endpoint ip configured as variable.

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

Example-2: This example demonstrates how to create an IPv4 endpoint API URL tracker under transport profile with tracker name and endpoint API URL configured as global value.

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: transport1
        ipv6_trackers:
          - name: ipv6_api_tracker
            description: API URL Tracker
            endpoint_dns_name: example.com
            tracker_name: transport_ipv6_api_tracker
```

Example-3: This example demonstrates how to create an IPv4 endpoint DNS tracker under transport profile with tracker name and endpoint DNS configured as global value.

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: transport1
        ipv6_trackers:
          - name: ipv6_dns_tracker
            description: DNS Tracker
            endpoint_dns_name: example.com
            tracker_name: transport_ipv6_dns_tracker
```
