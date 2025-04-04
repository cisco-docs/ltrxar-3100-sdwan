# Traffic Data - Custom Definition

Custom sequences enable fine-grained control and customization over how traffic is handled within the SD-WAN network.

For example, a custom sequence in a data policy might include rules to identify specific applications, source/destination IP addresses and/or ports, or other attributes of network traffic. Based on these rules, the data policy can determine how to treat the identified traffic: prioritizing it, applying Quality of Service (QoS) actions, steering it through a specific path or service chain, among some other action types.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure Traffic Data policy, which matching traffic based on Application Group (VOICE-APPS and BUSINESS-APPS, etc) and applying Quality of Service (QoS) action (defining forwarding class and DSCP value), and for the low priority applications steering traffic to specific transport with restrict option enabled. Each sequence has also counter configured.

```yaml
sdwan:
  centralized_policies:
    definitions:
          - name: DP-VPN10-01
            description: DP-VPN10-01
            default_action_type: accept
            sequences:
              - base_action: accept
                id: 1
                name: TRAFFIC-QOS
                ip_type: ipv4
                type: custom
                match_criterias:
                  application_list: VOICE-APPS
                actions:
                  counter_name: DP-VOICE-APPS
                  forwarding_class: CLASS-REALTIME
                  dscp: 46
              - base_action: accept
                id: 2
                name: TRAFFIC-QOS
                ip_type: ipv4
                type: custom
                match_criterias:
                  application_list: BUSINESS-APPS
                actions:
                  counter_name: DP-BUSINESS
                  forwarding_class: CLASS-BUSINESS
                  dscp: 26
              - base_action: accept
                id: 3
                name: TRAFFIC-QOS
                ip_type: ipv4
                type: custom
                match_criterias:
                  application_list: BULK-APPS
                actions:
                  counter_name: DP-BULK
                  forwarding_class: CLASS-BULK
                  dscp: 10
              - base_action: accept
                id: 4
                name: LOW-Priority-TLOC
                ip_type: ipv4
                type: custom
                match_criterias:
                  application_list: LOW-PRIORITY-APPS
                actions:
                  counter_name: DP-LOW-PRIORITY
                  forwarding_class: CLASS-LOW-PRIORITY
                  dscp: 8
                  local_tloc_list:
                    colors: 
                      - "biz-internet"
                    encaps: 
                      - ipsec
                    restrict: true
```

Example-2: This example demonstrates how to configure Traffic Data policy for Direct internet access usecase (Guest VPN). It is matching on data prefix list to drop traffic to spesific destinations and in another sequence steering traffic to the VPN 0 with nat_vpn action.

```yaml
          - name: DP-VPN-02
            description: DP-VPN-GUEST
            default_action_type: accept
            sequences:
              - base_action: drop
                id: 1
                name: BOGON DROP
                ip_type: ipv4
                type: custom
                match_criterias:
                  destination_data_prefix_list: DPL-BOGON-ADDR
                actions:
                  counter_name: DPL-BOGON-ADDR-DROP
              - base_action: accept
                id: 10
                name: DIA
                ip_type: ipv4
                type: custom
                match_criterias:
                  source_data_prefix: 0.0.0.0/0
                actions:
                  counter_name: DPL-DIA
                  nat_vpn:
                    vpn_id: 0

```