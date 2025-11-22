# IPv6 Prefix List

Configure IPv6 prefix lists.

{{ doc_gen }}

### Examples

Example-1: IPv6 Prefix Lists for Traffic Filtering in SD-WAN

In an SD-WAN deployment, IPv6 prefix lists help administrators define and enforce routing policies by specifying allowed and restricted IPv6 prefixes. This use case defines a policy object containing two IPv6 prefix lists: AllowedIPv6Prefixes and BlockedIPv6Prefixes. The AllowedIPv6Prefixes list includes specific IPv6 subnets that are permitted for routing, ensuring secure access for internal communication and business-critical applications. The optional ge (greater than or equal to) and le (less than or equal to) parameters provide flexibility in defining prefix length constraints. The BlockedIPv6Prefixes list defines IPv6 prefixes that should be restricted, preventing access to untrusted networks. By implementing IPv6 prefix lists, network administrators can ensure secure, optimized, and policy-driven IPv6 traffic management in their SD-WAN environment.

```yaml
sdwan:
  policy_objects:
    ipv6_prefix_lists:
      - name: AllowedIPv6Prefixes
        entries:
          - prefix: 2001:db8:100::/48
          - prefix: 2001:db8:200::/64
            le: 96
          - prefix: 2001:db8:300::/32
            ge: 48
      - name: BlockedIPv6Prefixes
        entries:
          - prefix: fd00::/8
          - prefix: 2001:db8:dead::/48
            le: 64
```