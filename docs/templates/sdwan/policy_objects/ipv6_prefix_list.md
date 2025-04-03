# IPv6 Prefix List

Configure IPv6 prefix lists.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure an IPv6 prefix list that matches the "fe40:5657:6df1:d34f::/64" prefix (strict), all prefixes within the "fc00::/7" range with a subnet mask length greater than or equal to 100, and less than or equal to 120.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      ipv6_prefix_lists:
        - name: ipv6_pl_private
          entries:
            - prefix: fe40:5657:6df1:d34f::/64
            - prefix: fc00::/7
              ge: 100
              le: 120
```
