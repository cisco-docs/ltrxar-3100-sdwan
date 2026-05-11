# Security Local Domain List

Configure Security Local Domain list for UTD (Unified Threat Defense) DNS security features.

{{ doc_gen }}

### Examples

Example-1: This example shows the configuration for the Security Local Domain list with domain patterns for internal DNS resolution.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      security_local_domain_lists:
        - name: security_local_domain
          local_domains:
            - internal.corp.local
            - .*internal.example.com
```
