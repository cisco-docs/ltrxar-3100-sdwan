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
                id: 1
                name: 1strule
                ip_type: ipv4
                type: service_chaining
                match_criterias:
                  - application_list: all_good_applications
                  - dscp: 54
                  - packet_length: 1150
                  - plp: high
                  - protocols:
                      - 6
                      - 7
                      - 8
                  - source_data_prefix_list: allindia_prefixes
                  - source_data_prefix: 10.1.1.0/24
                  - source_ports:
                      - 676
                      - 53
                  - destination_data_prefix_list: allus_prefixes
                  - destination_data_prefix: 10.2.1.0/24
                  - destination_ports:
                      - 443
                      - 8080
                  - tcp: 'syn'
                actions:
                  - log: enabled
                  - counter_name: abc
                  - set_parameters:
                    - service:
                        type: FW
                        vpn: 567
                        tloc:
                          ip: 10.10.5.66
                          color: biz-internet
                          encap: ipsec
                        local: enabled
                        restrict: enabled
              - base_action: accept
                id: 2
                name: rulenew
                ip_type: ipv4
                type: service_chaining
                match_criterias:
                  - application_list: all_bad_applications
                  - dscp: 56
                  - packet_length: 1500
                  - plp: low
                  - protocols:
                      - 53
                  - source_data_prefix_list: allus_prefixes
                  - source_data_prefix: 10.3.1.0/24
                  - source_ports:
                      - 61345
                      - 8080
                  - destination_data_prefix_list: allin_prefixes
                  - destination_data_prefix: 10.4.1.0/24
                  - destination_ports:
                      - 443
                      - 8080
                  - tcp: 'syn'
                actions:
                  - set_parameters:
                    - tloc:
                        tloc_list: jdghad
                    - vpn: 512
```
