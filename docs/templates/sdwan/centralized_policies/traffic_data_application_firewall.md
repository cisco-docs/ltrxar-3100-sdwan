# Traffic Data - Application FIrewall Definition

Application FIrewall Definition define the matching conditions and Actions to configure Application FIrewall

{{ doc_gen }}

### Examples

```yaml
sdwan:
  centralized_policies:
    definitions:
      data_policy:
        traffic_data:
          - name: test_policy
            description: test_policy_description
            default_action_type: accept
            sequences:
              - base_action: drop
                id: 1
                name: application_firewall_1
                ip_type: ipv4
                type: application_firewall
                match_criterias:
                  - application_list: all_good_applications
                  - dscp: 54
                  - packet_length: 1150
                  - plp: high
                  - protocols:
                      - 6
                      - 7
                      - 8
                  - source_data_prefix_list: east_prefixes
                  - source_data_prefix: 10.10.1.1/24
                  - source_ports:
                      - 676
                      - 53
                  - destination_data_prefix_list: west_prefixes
                  - destination_data_prefix: 10.20.1.1/24
                  - destination_ports:
                      - 443
                      - 8080
                  - tcp: 'syn'
                actions:
                  - counter: abc
                  - log: enabled
```