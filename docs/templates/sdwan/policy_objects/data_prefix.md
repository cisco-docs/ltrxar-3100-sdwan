# Data Prefix List

A data prefix list specifies one or more IP prefixes. You can specify both unicast and multicast addresses.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  localized_policies:
    lists:
      dataPrefix:
        - name: DPL-DEFAULT
          description: "Default IPv4 prefix"
          entries:
          - ipPrefix: 0.0.0.0/0
          - ipPrefix: 1.1.1.1/32
```
