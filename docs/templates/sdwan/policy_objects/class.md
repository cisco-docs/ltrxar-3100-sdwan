# Class

Configure QoS class maps.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  localized_policies:
    lists:
      class:
        - name: CLASS-REALTIME
          description: "Realtime QoS Class"
          entries:
          - queue: '0'
```
