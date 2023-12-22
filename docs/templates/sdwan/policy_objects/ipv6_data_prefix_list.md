# IPv4 Data Prefix List

An IPv6 data prefix list specifies one or more IPv6 prefixes. You can specify both unicast and multicast addresses.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    ipv6_data_prefix_lists:
      - name: DPL-PRIVATE
        prefixes:
          - fe40:5657:6df1:d34f::/64
          - fc00::/7
```
