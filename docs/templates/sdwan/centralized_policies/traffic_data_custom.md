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
                name: rule5
                ip_type: ipv4
                type: custom
                match_criterias:
                  application_list: APP-LIST-TD-TEST2
                  dns_application_list: APP-LIST-TD-TEST2
                  dns: request
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
                  traffic_to: access
                actions:
                  nat_vpn: 
                    vpn_id: 0
                    nat_vpn_fallback: false
                  redirect_dns:
                    type: ipAddress
                    ip_address: 8.2.2.2
                  appqoe_optimization:
                    tcp: true
                    dre: true
                    service_node_group: SNG-APPQOE21
                  dscp: 42
                  forwarding_class: video_live
                  local_tloc_list: 
                    restrict: true
                    colors:
                      - custom1
                      - custom2
                    encaps:
                      - ipsec
```