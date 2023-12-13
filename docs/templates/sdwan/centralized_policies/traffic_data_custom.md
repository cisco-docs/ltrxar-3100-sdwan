# Traffic Data - Custom Definition

Custom sequences enable fine-grained control and customization over how traffic is handled within the SD-WAN network.

For example, a custom sequence in a data policy might include rules to identify specific applications, source/destination IP addresses and/or ports, or other attributes of network traffic. Based on these rules, the data policy can determine how to treat the identified traffic: prioritizing it, applying Quality of Service (QoS) actions, steering it through a specific path or service chain, among some other action types.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  centralized_policies:
    definitions:
      data_policy:
        traffic_data:
          - name: Uplink_Selection_for_DIA
            description: Prefer Particular Uplink for Direct Internet Access
            default_action_type: reject
            sequences:
              - base_action: accept
                id: 5
                name: rule3
                ip_type: ipv4
                type: custom
                match_criterias:
                  - application_list: APP-LIST-TD-TEST2
                  - dns_application_list: APP-LIST-TD-TEST2
                  - dns: request
                  - dscp: 54
                  - packet_length: 1150
                  - plp: high
                  - protocols:
                      - 89
                      - 90
                      - 91
                  - source_data_prefix_list: PREFIX-LIST-TD-TEST2
                  - source_data_prefix: 10.2.1.0/24
                  - source_ports:
                      - 576
                      - 80
                  - destination_data_prefix_list: PREFIX-LIST-TD-TEST1
                  - destination_data_prefix: 10.1.1.0/24
                  - destination_ports:
                      - 443
                      - 8080
                  - destination_region: primary-region
                  - tcp: 'syn'
                  - traffic_to: access
                actions:
                  - log: enabled
                  - counter_name: LOGGER-TD-TEST2
                  - cflowd: enabled
                  - sig: enabled
                    sig_fallback_to_routing: false
                  - loss_correction: fecAdaptive
                    loss_threshold_percentage: 5
                  - nat_vpn: 0
                    nat_vpn_fallback: true
                  - redirect_dns_type: ipAddress
                    redirect_dns_ip_address: 8.2.2.2
                  - appqoe_optimization_tcp: true
                    appqoe_optimization_dre: false
                  - set_parameters:
                    - dscp: 42
                    - forwarding_class: video_live
                    - local_tloc_list: 
                        restrict: allow
                        colors:
                          - mpls
                          - biz-internet
                        encaps:
                          - ipsec
                          - gre
                    - next_hop: 100.10.10.4
                      when_next_hop_is_not_available: route_table_entry
                    - policer_list: POLICER-TD-TEST1
                    - service:
                        type: FW
                        vpn: 62
                        tloc:
                          ip: 10.59.160.1
                          color: gold
                          encap: ipsec
                        local: enabled
                        restrict: enabled
```