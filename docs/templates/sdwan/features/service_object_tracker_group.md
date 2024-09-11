# Service Object Tracker Group Feature

Configure Service Object Tracker Group.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: basic_service
        object_tracker_groups:
          - name: tracker_group1
            id: 10
            trackers:
              - interface_tracker1
              - interface_tracker2
        object_trackers:
          - name: interface_tracker1
            id: 1
            type: Interface
            interface_name: GigabitEthernet1
          - name: interface_tracker2
            id: 2
            type: Interface
            interface_name: GigabitEthernet2
```
