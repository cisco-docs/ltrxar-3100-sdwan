# Security Port List

A security port list is a user-defined collection of TCP/UDP ports and port ranges used when configuring next-generation firewall (NGFW) policies within policy groups.

{{ doc_gen }}

### Examples

Example-1: This example illustrates how to configure a security port list that includes application-specific ports 12346 and 23456, as well as a range of well-known ports from 5060 to 6082.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      security_port_lists:
        - name: app_spec_ports
          ports:
            - 12346
            - 23456
            - 5060-6082
```
