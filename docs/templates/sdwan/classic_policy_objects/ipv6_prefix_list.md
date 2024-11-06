# IPv6 Prefix List

Configure IPv6 prefix lists.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    ipv6_prefix_lists:
      - name: PLV4-PRIVATE-RANGES
        entries:
          - prefix: fe40:5657:6df1:d34f::/64
          - prefix: fc00::/7
            ge: 120
```
