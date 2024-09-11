# Transport IPv6 Tracker Group Feature

Configure IPv6 Tracker Group.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: basic_transport
        ipv6_tracker_groups:
          - name: tracker_group_feature
            tracker_name: tracker3
            tracker_boolean: and
            trackers:
              - tracker1_feature
              - tracker2_feature
        ipv6_trackers:
          - name: tracker1_feature
            endpoint_ip: 2001:db8:1::1
            tracker_name: tracker1
          - name: tracker2_feature
            endpoint_ip: 2001:db8:1::2
            tracker_name: tracker2
```
