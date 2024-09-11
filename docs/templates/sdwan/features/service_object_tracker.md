# Service Object Tracker Feature

Configure Service Object Tracker for Interface, SIG or Route.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: basic_service
        object_trackers:
          - name: tracker1
            id: 1
            type: Interface
            interface_name: GigabitEthernet1
```
