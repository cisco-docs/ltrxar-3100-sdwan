# Application Priority Traffic Policy

Application Priority Traffic Policy enables intelligent traffic steering and quality of service management by combining Application Aware Routing with traffic classification and action enforcement. Policies define sequences that match specific traffic patterns based on applications, IP addresses, ports, or DSCP values, and apply targeted actions such as SLA-based path selection, QoS remarking, NAT configuration, security service insertion, and application optimization to ensure optimal network performance and user experience.

{{ doc_gen }}

## Configuration Prerequisites

Traffic policies reference VPNs that must be defined in service profiles. The examples below reference vpn10 and vpn20, which should be configured:

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: branch-service-profile
        lan_vpns:
          - name: vpn10
            vpn_id: 10
          - name: vpn20
            vpn_id: 20
```

Additionally, the examples reference policy objects that should be predefined:
- Application lists (voice-apps, video-apps, business-apps, etc.)
- SLA class lists (sla-voice, sla-video, sla-business, etc.)
- Forwarding class lists (class-realtime, class-video, class-business, etc.)
- Data prefix lists (dpl-bogon-addresses)
- Color groups (color-group-mpls-biz)
- Policer lists (policer-business)
- Service node groups (sng-appqoe)

## Examples

Example 1: This example demonstrates Application Aware Routing functionality for intelligent path selection, matching traffic based on application groups (voice-apps, business-apps, etc.) and applying SLA class steering with preferred colors or color groups, with options for strict enforcement or fallback to best path when SLA is not met. Each sequence has counter enabled for monitoring.

```yaml
sdwan:
  feature_profiles:
    application_priority_profiles:
      - name: branch-app-priority-profile
        traffic_policies:
          - name: aar-branch-policy
            description: Application Aware Routing policy for branch offices
            default_action: accept
            vpns:
              - vpn10
              - vpn20
            direction: service
            sequences:
              - sequence_id: 1
                sequence_name: aar_voice
                base_action: accept
                protocol: ipv4
                match_entries:
                  application_list: voice-apps
                actions:
                  sla_class:
                    sla_class_list: sla-voice
                    preferred_colors:
                      - mpls
                      - metro-ethernet
                    strict: true
                  counter_name: aar-voice-counter
                  log: true
              - sequence_id: 2
                sequence_name: aar_video
                base_action: accept
                protocol: ipv4
                match_entries:
                  application_list: video-apps
                actions:
                  sla_class:
                    sla_class_list: sla-video
                    preferred_colors:
                      - mpls
                      - biz-internet
                    fallback_to_best_path: true
                  counter_name: aar-video-counter
                  log: true
              - sequence_id: 3
                sequence_name: aar_business
                base_action: accept
                protocol: ipv4
                match_entries:
                  application_list: business-apps
                actions:
                  sla_class:
                    sla_class_list: sla-business
                    preferred_color_group: color-group-mpls-biz
                    fallback_to_best_path: true
                  counter_name: aar-business-counter
                  log: true
              - sequence_id: 4
                sequence_name: aar_bulk
                base_action: accept
                protocol: ipv4
                match_entries:
                  application_list: bulk-apps
                actions:
                  sla_class:
                    sla_class_list: sla-bulk
                    preferred_colors:
                      - biz-internet
                    fallback_to_best_path: true
                  counter_name: aar-bulk-counter
                  log: true
              - sequence_id: 5
                sequence_name: aar_default
                base_action: accept
                protocol: ipv4
                match_entries:
                  source_ipv4_prefix: 0.0.0.0/0
                actions:
                  sla_class:
                    sla_class_list: sla-default
                    preferred_colors:
                      - biz-internet
                    fallback_to_best_path: true
                  counter_name: aar-default-counter
                  log: true
```

Example 2: This example demonstrates Traffic Policy configuration with Quality of Service (QoS) actions, matching traffic based on application groups (voice-apps, business-apps, etc.) and applying DSCP marking, forwarding class assignment, and for lower priority applications steering traffic to specific transport with restrict option enabled. Each sequence has counter configured for monitoring.

```yaml
sdwan:
  feature_profiles:
    application_priority_profiles:
      - name: vpn10-app-priority-profile
        traffic_policies:
          - name: qos-vpn10-policy
            description: QoS traffic policy for VPN 10
            default_action: accept
            vpns:
              - vpn10
            direction: service
            sequences:
              - sequence_id: 1
                sequence_name: traffic_qos_voice
                base_action: accept
                protocol: ipv4
                match_entries:
                  application_list: voice-apps
                actions:
                  dscp: 46
                  forwarding_class: class-realtime
                  counter_name: qos-voice-counter
                  log: true
              - sequence_id: 2
                sequence_name: traffic_qos_video
                base_action: accept
                protocol: ipv4
                match_entries:
                  application_list: video-apps
                actions:
                  dscp: 34
                  forwarding_class: class-video
                  loss_correct_type: fec-adaptive
                  loss_correct_fec_threshold: 3
                  counter_name: qos-video-counter
                  log: true
              - sequence_id: 3
                sequence_name: traffic_qos_business
                base_action: accept
                protocol: ipv4
                match_entries:
                  application_list: business-apps
                actions:
                  dscp: 26
                  forwarding_class: class-business
                  policer_list: policer-business
                  counter_name: qos-business-counter
                  log: true
              - sequence_id: 4
                sequence_name: traffic_qos_bulk
                base_action: accept
                protocol: ipv4
                match_entries:
                  application_list: bulk-apps
                actions:
                  dscp: 10
                  forwarding_class: class-bulk
                  appqoe_optimization:
                    tcp_optimization: true
                    dre_optimization: true
                    service_node_group: SNG-APPQOE2
                  counter_name: qos-bulk-counter
                  log: true
              - sequence_id: 5
                sequence_name: low_priority_tloc
                base_action: accept
                protocol: ipv4
                match_entries:
                  application_list: low-priority-apps
                actions:
                  dscp: 8
                  forwarding_class: class-low-priority
                  local_tloc:
                    colors:
                      - biz-internet
                    encapsulation: ipsec
                    restrict: true
                  counter_name: qos-low-priority-counter
                  log: true
```


Example 3: This example demonstrates Direct Internet Access (DIA) policy for Guest VPN, matching on data prefix list to drop traffic to specific destinations (BOGON addresses) and in another sequence steering traffic to VPN 0 with NAT action for internet access.

```yaml
sdwan:
  feature_profiles:
    application_priority_profiles:
      - name: guest-vpn-app-priority-profile
        traffic_policies:
          - name: dia-guest-vpn-policy
            description: DIA policy for Guest VPN
            default_action: accept
            vpns:
              - vpn20
            direction: service
            sequences:
              - sequence_id: 1
                sequence_name: bogon_drop
                base_action: drop
                protocol: ipv4
                match_entries:
                  destination_data_ipv4_prefix_list: dpl-bogon-addresses
                actions:
                  counter_name: bogon-drop-counter
                  log: true
              - sequence_id: 2
                sequence_name: dia_internet
                base_action: accept
                protocol: ipv4
                match_entries:
                  source_ipv4_prefix: 0.0.0.0/0
                actions:
                  nat_vpn:
                    nat_vpn_0: true
                  counter_name: dia-counter
                  log: true
```