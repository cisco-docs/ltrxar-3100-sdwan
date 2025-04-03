# System Feature Profile

Using a system profile, you can specify the system-wide configuration of your WAN Edge router.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure a system feature profile with a name (which is mandatory) and a description (which is optional).

```yaml
sdwan:
  feature_profiles:
    system_profiles:
      - name: system
        description: basic system profile
```
