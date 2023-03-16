# Data Prefix List

A data prefix list specifies one or more IP prefixes. You can specify both unicast and multicast addresses.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  policy_objects:
    lists:
      dataPrefix:
        - name: DPL-PRIVATE
          description: "Private IPv4 prefix"
          entries:
          - ipPrefix: 10.0.0.0/8
          - ipPrefix: 172.16.0.0/12
```
