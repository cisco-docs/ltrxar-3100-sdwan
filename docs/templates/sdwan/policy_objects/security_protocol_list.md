# Security Protocol List

A security protocol list is a collection of protocol names used when configuring next-generation firewall (NGFW) policies within policy groups.

{{ doc_gen }}

### Examples

Example-1: This example illustrates the configuration of a security protocol list that includes the well-known protocols ICMP, TCP, and UDP.

```yaml
sdwan:
  feature_profiles:
    policy_object_profile:
      security_protocol_lists:
        - name: sec_proto_list1
          protocols:
            - icmp
            - tcp
            - udp
```
