# Forwarding Class

Configure QoS forwarding class.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure two forwarding classes: one named "realtime" assigned to queue 0 and one named "transactional" assigned to queue 1.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      forwarding_classes:
        - name: realtime
          queue: 0
        - name: transactional
          queue: 1
```
