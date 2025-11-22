# Application Priority Feature Profile

Using an application priority profile, you can specify application-aware QoS policies and traffic prioritization configuration for your WAN Edge router.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure an application priority feature profile with a name (which is mandatory) and a description (which is optional).

```yaml
sdwan:
  feature_profiles:
    application_priority:
      - name: app_priority
        description: basic application priority profile
```