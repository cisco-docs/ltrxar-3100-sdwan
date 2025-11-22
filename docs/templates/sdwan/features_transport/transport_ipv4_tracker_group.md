# Transport IPv4 Tracker Group Feature

Configure IPv4 Tracker Group.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure an IPv4 tracker group under the transport feature profile with two trackers assigned to a group and a boolean logic set to "and" (meaning both trackers needs to be up for the tracker group to be up).

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: basic_transport
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

Example-2: This example demonstrates how to configure an IPv4 tracker group under the transport feature profile with two trackers assigned to a group and a boolean logic set to "or" (meaning either one of the trackers needs to be up for the tracker group to be up).

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: basic_transport
        ipv4_tracker_groups:
          - name: tracker_group_feature
            tracker_boolean: or
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
