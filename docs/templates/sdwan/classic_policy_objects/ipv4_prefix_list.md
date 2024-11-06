# IPv4 Prefix List

Configure IPv4 prefix lists.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    ipv4_prefix_lists:
      - name: PLV4-PRIVATE-RANGES
        entries:
          - prefix: 10.0.0.0/8
          - prefix: 172.16.0.0/12
            le: 30
          - prefix: 192.168.0.0/16
            ge: 24
            le: 28
```
