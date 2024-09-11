# CLI Feature

Configure additional CLI commands on the device.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    cli_profiles:
      - name: cli
        description: basic cli profile
        config:
          name: cli-config
          cli_configuration: |
            ! Enable new BGP community format
            ip bgp-community new-format
```
