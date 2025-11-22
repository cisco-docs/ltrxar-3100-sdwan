# IPv4 Data Prefix List

An `IPv4 data prefix list` specifies a group of destination prefixes. You can specify both unicast and multicast addresses.

{{ doc_gen }}

### Examples

Example-1: Create IPv4 Data Prefix List
This example demonstrates how to create an IPv4 Data Prefix List named RFC1918 that includes 10.0.0.0/8, 172.16.0.0/12 and 192.168.0.0/16.

```yaml
sdwan:
  policy_objects:
    ipv4_data_prefix_lists:
      - name: RFC1918
        prefixes:
          - 10.0.0.0/8
          - 172.16.0.0/12
          - 192.168.0.0/16
```

Example-2: Create IPv4 Data Prefix List for multicast
This example demonstrates how to create an IPv4 Data Prefix List named private-mcast that includes 239.0.0.0/8.

```yaml
sdwan:
  policy_objects:
    ipv4_data_prefix_lists:
      - name: Private-MCAST
        prefixes:
          - 239.0.0.0/8
```
