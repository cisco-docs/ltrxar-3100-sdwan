# Traffic Data - QOS Definition

QOS Definition define the matching conditions and Actions to configure QOS policy for Traffic data

{{ doc_gen }}

### Examples

```yaml
sdwan:
  centralized_policies:
    definitions:
      data_policy:
        traffic_data:
          - name: data_policy_qos1
            description: data_policy_qos1
            default_action_type: accept
            sequences:
              - base_action: accept
                id: 1
                name: 1strule
                ip_type: ipv4
                type: qos
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
                  - loss_correction: fecAdaptive
                    loss_threshold_percentage: 3
                  - set_parameters:
                    - dscp: 42
                    - forwarding_class: video_live
                    - policer_list: test_list_policer
```