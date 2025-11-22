# IPv6 Data Prefix List

An IPv6 data prefix list specifies one or more IPv6 prefixes. You can specify both unicast and multicast addresses.

{{ doc_gen }}

### Examples

Example-1: IPv6 Data Prefix Lists for Traffic Filtering 

In an SD-WAN deployment, IPv6 data prefix lists enable administrators to define and control network prefixes for routing, security, and policy enforcement. This use case defines a policy object that includes two IPv6 prefix lists: TrustedIPv6Networks and RestrictedIPv6Networks. The TrustedIPv6Networks list includes IPv6 prefixes that are permitted for routing, ensuring secure communication for internal and business-critical applications. The RestrictedIPv6Networks list defines IPv6 prefixes that should be filtered or have limited access, helping to prevent unauthorized traffic from reaching sensitive network segments. By implementing IPv6 prefix lists, network administrators can enhance security, traffic optimization, and compliance with SD-WAN policies.

```yaml
sdwan:
  policy_objects:
    ipv6_data_prefix_lists:
      - name: TrustedIPv6Networks
        prefixes:
          - 2001:db8:1::/48
          - 2001:db8:2::/64
      - name: RestrictedIPv6Networks
        prefixes:
          - fd00::/8
          - 2001:db8:dead::/48
```
