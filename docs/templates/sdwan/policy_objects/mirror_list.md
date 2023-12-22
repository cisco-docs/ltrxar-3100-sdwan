# Mirror Lists

Specify configuration for packet mirroring.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    mirror_lists:
      - name: MIR1
        remote_destination_ip: 10.0.0.1
        source_ip: 192.168.1.100
```
