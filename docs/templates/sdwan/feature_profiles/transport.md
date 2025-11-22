# Transport Feature Profile

Using a transport profile, you can specify the transport (WAN) side configuration.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure a transport feature profile with a name (which is mandatory) and a description (which is optional).

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: transport
        description: basic transport profile
```
