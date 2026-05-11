# Security Local Application List

Configure Security Local Application list.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure a Security Local Application list with applications and application families.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      security_local_application_lists:
        - name: security_local_app
          applications:
            - audible-com
            - windows-update
          application_families:
            - web
            - authentication
```
