# IPv4 Prefix List

Configure IPv4 prefix lists.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure an IPv4 prefix list that matches the "10.0.0.0/8" prefix (strict), all prefixes within the "172.16.0.0/12" range with a subnet mask length less than or equal to 30, and all prefixes within the "192.168.0.0/16" range with a subnet mask length greater than or equal to 24 and less than or equal to 28.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      ipv4_prefix_lists:
        - name: ipv4_pl_private
          entries:
            - prefix: 10.0.0.0/8
            - prefix: 172.16.0.0/12
              le: 30
            - prefix: 192.168.0.0/16
              ge: 24
              le: 28
```

