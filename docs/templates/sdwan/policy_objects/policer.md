# Policer List

Configure policers to control the maximum rate of traffic sent or received on an interface, and to partition a network into multiple priority levels.

{{ doc_gen }}

### Examples

Example-1: This examples demonstrates how to configure a policer with burst bytes, policer rate and exceed_action remark.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      policers:
        - name: branch_policer
          burst_bytes: 2000000
          exceed_action: remark
          rate_bps: 250000000
```
