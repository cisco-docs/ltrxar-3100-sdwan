# Transport IPv6 Access Control List Feature

Configure IPv6 access control lists (ACLs) to influence the traffic flowing in or out the interfaces.

{{ doc_gen }}

### Examples

Example-1: The example below demonstrates how to configure transport IPv6 access list with default action accept and two sequences. Sequence 1 matches all web traffic destined to 2001:db8:1::/64 coming with traffic class value of 46, from 2001:db8:2::/64 with specific source ports 1023, 60000-65535. This traffic is logged and counter is applied. Sequence 2 matches all traffic coming with traffic class 48, remarks to traffic class 46 with log and counter applied.

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: basic_transport
        ipv6_acls:
          - name: vpn0_ipv6_acl_out
            description: "control vpn 0 outbound traffic"
            default_action: accept
            sequences:
              - id: 1
                name: "Allow-ICMPv6"
                base_action: accept
                match_entries:
                  destination_data_prefix: 2001:db8:1::/64
                  source_data_prefix: 2001:db8:2::/64
                  source_ports:
                    - 60000-65535
                    - 1023
                  destination_ports:
                    - 80
                    - 443-444
                  traffic_classes:
                    - 46
                actions:
                  log: true
                  counter_name: "IPv6ACLCounter"
              - id: 2
                name: "remark"
                base_action: accept
                match_entries:
                  traffic_classes:
                    - 48
                actions:
                  log: true
                  traffic_class: 46
                  counter_name: "RemarkCounter"
```
