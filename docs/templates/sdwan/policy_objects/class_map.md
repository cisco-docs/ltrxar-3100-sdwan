# Class Map

Configure QoS class maps.

{{ doc_gen }}

### Examples

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
