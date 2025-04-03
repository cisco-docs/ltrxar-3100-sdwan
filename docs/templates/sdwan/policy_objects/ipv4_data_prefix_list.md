# IPv4 Data Prefix List

An IPv4 data prefix list specifies one or more IPv4 prefixes. You can specify both unicast and multicast addresses.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure an IPv4 data prefix list that matches three RFC1918 prefixes.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      ipv4_data_prefix_lists:
        - name: ipv4_dpl_private
          prefixes:
            - 10.0.0.0/8
            - 172.16.0.0/12
            - 192.168.0.0/16
```
