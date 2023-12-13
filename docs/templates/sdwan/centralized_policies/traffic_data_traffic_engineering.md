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
                id: 2
                name: traffic_engineering_1
                ip_type: ipv4
                type: traffic_engineering
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
                  - set_parameters:
                    - next_hop: 10.2.1.1
                      when_next_hop_is_not_available: route_table_entry
                    - tloc_list: TLOC-LIST-TD-TEST1
                    - tloc:
                        ip: 10.10.5.66
                        color: biz-internet
                        encap: ipsec
                    - vpn: 1
                    - local_tloc_list: 
                        restrict: restrict
                        colors:                                           
                          - custom1
                          - custom2
                        encaps:
                          - ipsec
                          - gre 

```