# IPv6 Data Prefix List

An IPv6 data prefix list specifies one or more IPv6 prefixes. You can specify both unicast and multicast addresses.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      ipv6_data_prefix_lists:
        - name: ipv6_dpl_private
          prefixes:
            - fe40:5657:6df1:d34f::/64
            - fc00::/7
```
