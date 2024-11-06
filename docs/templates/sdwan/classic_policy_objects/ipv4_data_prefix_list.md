# IPv4 Data Prefix List

An IPv4 data prefix list specifies one or more IPv4 prefixes. You can specify both unicast and multicast addresses.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  policy_objects:
    ipv4_data_prefix_lists:
      - name: DPL-PRIVATE
        prefixes:
          - 10.0.0.0/8
          - 172.16.0.0/12
```
