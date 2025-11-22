# Traffic Data - Traffic Engineering Definition

Traffic Engineering Definition define the matching conditions and Actions to configure Traffic Engineering

{{ doc_gen }}

### Examples

```yaml
sdwan:
  centralized_policies:
    definitions:
      data_policy:
        traffic_data:
          - name: test_traffic_engineering1
            description: test_traffic_engineering1
            default_action_type: accept
            sequences:
              - base_action: accept
                id: 3
                name: rule3
                ip_type: ipv4
                type: traffic_engineering
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
                  tloc_list: TLOC-LIST-TD-TEST1
                  tloc:
                    ip: 10.10.54.97
                    color: custom2
                    encap: ipsec
                  vpn: 6
                  local_tloc_list: 
                    restrict: true
                    colors:
                      - custom1
                      - custom2
                    encaps:
                      - ipsec
                  next_hop: 
                    ip_address: 10.10.10.4
                    when_next_hop_is_not_available: route_table_entry
```