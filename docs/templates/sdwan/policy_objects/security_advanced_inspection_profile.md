# Security Advanced Inspection Profile

Configure Security Advanced Inspection Profile.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure a Security Advanced Inspection Profile with intrusion_prevention and tls_action.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      security_advanced_inspection_profiles:
        - name: advanced_inspection_basic
          intrusion_prevention: intrusion_prevention_basic
          tls_action: skip_decrypt
```
