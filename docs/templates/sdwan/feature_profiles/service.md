# Service Feature Profile

Using a service profile, you can specify the service-side (LAN) configuration of your WAN Edge router.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure a service feature profile with a name (which is mandatory) and a description (which is optional).

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: service
        description: basic service profile
```
