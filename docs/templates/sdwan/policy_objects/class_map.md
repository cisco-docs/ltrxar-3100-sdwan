# Class Map

Configure QoS class maps.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    class_maps:
      - name: CLASS-REALTIME
        queue: 0
      - name: TRANSACTIONAL
        queue: 1
```
