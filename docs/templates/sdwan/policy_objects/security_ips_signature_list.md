# Security IPS Signature List

Configure Security IPS Signature list.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure a Security IPS Signature list with generator_id and signature_id.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      security_ips_signature_lists:
        - name: security_ips_signature
          entries:
            - generator_id: 1234
              signature_id: 5678
```
