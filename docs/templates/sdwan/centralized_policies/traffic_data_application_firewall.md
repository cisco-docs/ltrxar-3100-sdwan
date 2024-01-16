# Traffic Data - Application Firewall Definition

Application Firewall Definition define the matching conditions and Actions to configure Application Firewall

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
                id: 4
                name: rule4
                ip_type: ipv4
                type: application_firewall
                match_criterias:
                  application_list: APP-LIST-TD-TEST2
                  dscp: 54
                  packet_length: 1150
                  plp: high
                  protocols:
                    - 89
                    - 90
                    - 91
                  source_data_prefix_list: PREFIX-LIST-TD-TEST2
                  source_data_prefix: 10.2.1.0/24
                  source_ports:
                    - 676
                    - 53
                  source_port_ranges:
                    - from: 1001
                      to: 2000
                    - from: 3001
                      to: 4000
                  destination_data_prefix_list: PREFIX-LIST-TD-TEST1
                  destination_data_prefix: 10.1.1.0/24
                  destination_ports:
                    - 676
                    - 53
                  destination_port_ranges:
                    - from: 1001
                      to: 2000
                    - from: 3001
                      to: 4000
                  tcp: 'syn'
                actions:
                  log: true
                  counter_name: LOGGER-TD-TEST2
```