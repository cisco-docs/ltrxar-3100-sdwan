# Prefix List

Configure prefix lists.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  localized_policies:
    lists:
      prefix:
        - name: PLV4-PRIVATE-RANGES
          description: "IPv4 private ranges"
          entries:
            - ipPrefix: 10.0.0.0/8
            - ipPrefix: 172.16.0.0/12
```
