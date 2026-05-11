# Security Intrusion Prevention Profile

Configure Security Intrusion Prevention Profile.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure a Security Intrusion Prevention Profile with alert_log_level, custom_signature_set, inspection_mode, signature_allow_list, and signature_set.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      security_intrusion_prevention_profiles:
        - name: intrusion_prevention_full
          alert_log_level: critical
          custom_signature_set: false
          inspection_mode: detection
          signature_allow_list: security_ips_signature
          signature_set: balanced
```
