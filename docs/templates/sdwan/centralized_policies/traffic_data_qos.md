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
                name: rule1
                ip_type: ipv4
                type: qos
                match_criterias:
                  application_list: APP-LIST-TD-TEST1
                  dscp: 54
                  packet_length: 1150
                  plp: high
                  protocols:
                    - 6
                    - 7
                    - 8
                  source_data_prefix_list: PREFIX-LIST-TD-TEST1
                  source_data_prefix: 10.1.1.0/24
                  source_ports:
                    - 676
                    - 53
                  source_port_ranges:
                    - from: 1001
                      to: 2000
                    - from: 3001
                      to: 4000
                  destination_data_prefix_list: PREFIX-LIST-TD-TEST2
                  destination_data_prefix: 10.2.1.0/24
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
                  counter_name: LOGGER-TD-TEST1
                  dscp: 42
                  forwarding_class: video_live
                  policer_list: POLICER-TD-TEST1
                  loss_correction:
                    type: fecAlways
                    loss_threshold_percentage: 3
```