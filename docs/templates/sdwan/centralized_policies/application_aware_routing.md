# Traffic Data - Application Aware Routing

Application Aware Routing Definitions configure sequences of match-action pairs for dynamic traffic steering based on path characteristics of the data plane tunnels.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates how to configure Application Aware Routing policy, which matching traffic based on Application Group (VOICE-APPS and BUSINESS-APPS, etc) and as an actions applying target SLA classes together with preferred color (or color group) with option of fallback to the best path (transport) in case SLA is not met. Each sequence has counter enabled.

```yaml
sdwan:
  centralized_policies:
    definitions:
      data_policy:
        application_aware_routing:
          - name: AAR-Policy-v01
            description: General AAR policy
            default_action_type:
              sla_class_list: default
            sequences:
              - id: 1
                name: AAR-VOICE
                ip_type: ipv4
                type: app_route
                match_criterias:
                  application_list: VOICE-APPS
                actions:
                  counter_name: AAR-VOICE-APP
                  sla_class_list:
                    sla_class_list: SLA-VOICE
                    preferred_colors:
                      - "mpls"
                    when_sla_not_met: fallback_to_best_path
              - id: 2
                name: BUSINES-APPS
                ip_type: ipv4
                type: app_route
                match_criterias:
                  application_list: BUSINESS-APPS
                actions:
                  counter_name: AAR-BUSINESS-APPS
                  sla_class_list:
                    sla_class_list: SLA-BUSINESS
                    preferred_color_group: MPLS-BIZ
                    when_sla_not_met: fallback_to_best_path
              - id: 3
                name: BULK-APPS
                ip_type: ipv4
                type: app_route
                match_criterias:
                  application_list: BULK-APPS
                actions:
                  counter_name: AAR-BULK-APPS
                  sla_class_list:
                    sla_class_list: SLA-BULK
                    preferred_colors:
                      - "biz-internet"
                    when_sla_not_met: fallback_to_best_path
              - id: 4
                name: SLA-LOW-PRIORITY
                ip_type: ipv4
                type: app_route
                match_criterias:
                  application_list: LOW-PRIORITY-APPS
                actions:
                  counter_name: AAR-LOW-PRIORITY
              - id: 5
                name: Default
                ip_type: ipv4
                type: app_route
                match_criterias:
                  source_data_prefix: 0.0.0.0/0
                actions:
                  counter_name: AAR-Default
                  sla_class_list:
                    sla_class_list: SLA-DEFAULT
                    preferred_colors:
                      - "biz-internet"
                    when_sla_not_met: fallback_to_best_path    
```