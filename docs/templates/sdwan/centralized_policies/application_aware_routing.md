# Traffic Data - Application Aware Routing

Application Aware Routing Definition define the matching conditions and Actions to configure Application Aware Routing

{{ doc_gen }}

### Examples

```yaml
sdwan:
  centralized_policies:
    definitions:
      data_policy:
        application_aware_routing:
          - name: Test_application_aware_routing_number1
            description: Test_application_aware_routing_number1
            default_action_type: none
            sequences:
              - id: 1
                name: aar_rule
                ip_type: ipv4
                type: app_route
                match_criterias:
                  - application_list: saas_applications
                  - cloud_saas_application_list: salesforce
                  - dns_application_list: microsoft_apps
                  - dns: request
                  - dscp: 54
                  - plp: high
                  - protocols:
                      - 6
                      - 7
                  - source_data_prefix_list: aar_prefixes
                  - source_data_prefix: 10.1.1.0/24
                  - source_ports:
                      - 676
                      - 53
                  - destination_data_prefix_list: cloud_prefixes
                  - destination_data_prefix: 10.2.1.0/24
                  - destination_ports:
                      - 443 
                      - 8080
                  - traffic_to: core
                  - destination_region: primary-region
                actions:
                  - counter_name: abc
                  - log: enabled
                  - backup_sla_preferred_color: 3g
                  - sla_class_list_name: sla_class_list1
                    sla_class_list_preferred_color: mpls
                    sla_class_list_preferred_color_group: test_pref_color_group_2
                    sla_class_list_action_when_sla_not_met: strict_drop  # not defined in provider
                  - cloud_sla: enabled
```