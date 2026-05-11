# Security FQDN List

Configure Security FQDN list.

{{ doc_gen }}

### Examples

Example-1: This example shows the configuration for the Security FQDN list matching exact URL 'cisco.com' OR any URL that finishes with '.service-now.com' OR any URL that finishes with '.demo.acme.net'.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      security_fqdn_lists:
        - name: security_fqdn
          fqdns:
            - cisco.com
            - '*.service-now.com'
            - '*.demo.acme.net'
```
