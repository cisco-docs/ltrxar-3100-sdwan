# Transport IPv4 Access Control List Feature

Configure access control lists (ACLs) to influence the traffic flowing in or out the interfaces.

{{ doc_gen }}

### Examples

Example-1: The example below demonstrates how to configure transport IPv4 access list with default action accept and two sequences. Sequence 1 matches all traffic destined to 10.0.0.0/8 with DSCP 12, accepts the traffic, sets DSCP to 0 and apply counter. Sequence 2 matches all traffic desitned to 192.168.0.0/16, drops the traffic and logs the drop.

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: basic_transport
        ipv4_acls:
          - name: vpn0_acl_out
            description: "control vpn 0 outbound traffic"
            default_action: accept
            sequences:
              - id: 1
                base_action: accept
                match_entries:
                  destination_data_prefix: 10.0.0.0/8
                  dscps:
                    - 12
                    - 24
                actions:
                  dscp: 0
                  counter_name: remark-dscp
              - id: 2
                base_action: drop
                match_entries:
                  destination_data_prefix: 192.168.0.0/16
                actions:
                  log: true
```
