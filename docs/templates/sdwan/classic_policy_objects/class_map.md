# Class Map

Configure QoS class maps.

{{ doc_gen }}

### Examples

Example-1: This example shows the configuration to add QoS two class maps, Queue 0 for realtime and Queue 2 for default-class.

```yaml
sdwan:
  policy_objects:
    class_maps:
      - name: CLASS-REALTIME
        queue: 0
      - name: CLASS-DEFAULT
        queue: 2
```
