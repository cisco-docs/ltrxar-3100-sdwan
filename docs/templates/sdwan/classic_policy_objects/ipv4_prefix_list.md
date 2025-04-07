# IPv4 Prefix List

Configure IPv4 prefix lists.

{{ doc_gen }}

### Examples

Example-1: IPv4 Prefix Lists for Traffic Filtering in SD-WAN

In an SD-WAN deployment, IPv4 prefix lists are used to define allowed or denied network prefixes for traffic filtering, route control, and policy-based forwarding. This use case defines a policy object that includes two IPv4 prefix lists: AllowedPrefixes and RestrictedPrefixes. The AllowedPrefixes list includes specific subnets that are permitted for routing, ensuring business-critical applications and trusted networks have access. The RestrictedPrefixes list contains prefixes that should be filtered or have limited access, providing security by blocking unwanted traffic. The optional ge (greater than or equal to) and le (less than or equal to) parameters define subnet matching rules, allowing for fine-grained control over prefix filtering.

```yaml
sdwan:
  policy_objects:
    ipv4_prefix_lists:
      - name: AllowedPrefixes
        entries:
          - prefix: 192.168.10.0/24
          - prefix: 10.0.0.0/8
            le: 24
          - prefix: 172.16.0.0/16
            ge: 20
      - name: RestrictedPrefixes
        entries:
          - prefix: 198.51.100.0/24
          - prefix: 203.0.113.0/24
            le: 30
```