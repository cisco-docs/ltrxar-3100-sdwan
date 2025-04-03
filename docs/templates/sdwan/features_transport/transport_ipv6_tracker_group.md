# Transport IPv6 Tracker Group Feature

Configure IPv6 Tracker Group.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure an IPv6 tracker group under the transport feature profile with two trackers assigned to a group and a boolean logic set to "and" (meaning both trackers needs to be up for the tracker group to be up).

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

Example-2: This example demonstrates how to configure an IPv6 tracker group under the transport feature profile with two trackers assigned to a group and a boolean logic set to "or" (meaning either one of the trackers needs to be up for the tracker group to be up).

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
