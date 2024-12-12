# Service IPv4 Tracker Group Feature

Configure IPv4 Tracker Group.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: basic_service
        ipv4_tracker_groups:
          - name: tracker_group_feature
            tracker_boolean: and
            trackers:
              - tracker1_feature
              - tracker2_feature
        ipv4_trackers:
          - name: tracker1_feature
            endpoint_ip: 10.0.0.1
            tracker_name: tracker1
          - name: tracker2_feature
            endpoint_ip: 10.0.0.2
            tracker_name: tracker2
```
