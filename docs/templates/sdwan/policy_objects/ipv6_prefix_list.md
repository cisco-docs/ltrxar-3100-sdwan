# IPv6 Prefix List

Configure IPv6 prefix lists.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      ipv6_prefix_lists:
        - name: ipv6_pl_private
          entries:
            - prefix: fe40:5657:6df1:d34f::/64
            - prefix: fc00::/7
              ge: 120
```
