# Security Data IPv4 Prefix List

Configure Security Data IPv4 Prefix list.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure a Security Data IPv4 Prefix List that matches the "10.0.0.0/12" prefix.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      security_data_ipv4_prefix_lists:
        - name: security_data_ipv4_prefix
          prefixes:
            - 10.0.0.0/12
```
