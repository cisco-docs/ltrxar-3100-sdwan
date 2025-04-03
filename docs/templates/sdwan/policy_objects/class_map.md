# Class Map

Configure QoS class maps.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure two class maps: one named "realtime" assigned to queue 0 and one named "transactional" assigned to queue 1. Note that the description is optional.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      class_maps:
        - name: realtime
          queue: 0
        - name: transactional
          description: priority transactional traffic
          queue: 1
```
