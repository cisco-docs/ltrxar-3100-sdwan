# Mirror

Specify configuration for packet mirroring.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      mirrors:
        - name: mirror
          remote_destination_ip: 10.0.0.1
          source_ip: 192.168.1.100
```
