# Mirror

Specify configuration for packet mirroring.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure a mirror policy object with remote destination IP and source IP.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      mirrors:
        - name: mirror
          remote_destination_ip: 10.0.0.1
          source_ip: 192.168.1.100
```
