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
          - name: Test_application_aware_routing_number2
            description: Test_application_aware_routing_number2
            default_action_type:
              sla_class_list: default
            sequences:
              - id: 1
                name: aar_rule
                ip_type: ipv4
                type: app_route
                match_criterias:
                  application_list: APP-LIST-TD-TEST3
                  cloud_saas_application_list: APP-LIST-TD-TEST3
                  dns_application_list: APP-LIST-TD-TEST3
                  dns: request
                  dscp: 54
                  plp: high
                  protocols:
                    - 6
                  source_data_prefix_list: PREFIX-LIST-AAR-TEST3
                  source_data_prefix: 10.1.1.0/24
                  source_ports:
                    - 676
                  destination_data_prefix_list: PREFIX-LIST-AAR-TEST4
                  destination_data_prefix: 10.2.1.0/24
                  destination_ports:
                    - 676
                  traffic_to: core
                  destination_region: primary-region
                actions:
                  counter_name: abc
                  log: true
                  sla_class_list:
                    sla_class_list: Best-Effort-AAR
                    preferred_color_group: test_pref_color_group_2
                  cloud_sla: true
```