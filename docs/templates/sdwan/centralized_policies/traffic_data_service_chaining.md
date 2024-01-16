# Traffic Data - Service Chaining Definition

Service Chaining Definition define the matching conditions and Actions to configure Service Chaining

{{ doc_gen }}

### Examples

```yaml
sdwan:
  centralized_policies:
    definitions:
      data_policy:
        traffic_data:
          - name: Test_control_number1
            description: Test_control_number1
            default_action_type: accept
            sequences:
              - base_action: accept
                id: 2
                name: rule2
                ip_type: ipv4
                type: service_chaining
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
                  service:
                    type: FW
                    vpn: 62
                    tloc:
                      ip: 10.59.160.1
                      color: custom1
                      encap: ipsec 
```
