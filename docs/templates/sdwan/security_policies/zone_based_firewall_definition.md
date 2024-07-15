# Zone-Based Firewall

Zone-Based Firewall defines the matching conditions and actions to configure a firewall policy.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  security_policies:
    definitions:
      zone_based_firewall:
        - name: Test_zone_based_firewall
          description: Test_zone_based_firewall
          default_action_type: drop
          rules:
            - id: 1
              name: Rule_1
              base_action: pass
              match_criterias:
                source_data_prefix_lists:
                  - ZBFW_SDPL_1
                  - ZBFW_SDPL_2
                source_fqdn_lists:
                  - ZBFW_SFL_1
                  - ZBFW_SFL_2
                source_geo_locations:
                  - DZA
                  - AGO
                source_ports:
                  - 1045
                  - 1657
                source_port_ranges:
                  - from: 1331
                    to: 1442
                  - from: 1511
                    to: 1631
                destination_data_prefix_lists:
                  - ZBFW_DDPL_1
                  - ZBFW_DDPL_2
                destination_fqdn_lists:
                  - ZBFW_DFL_1
                  - ZBFW_DFL_2
                destination_geo_locations:
                  - DZA
                  - AGO
              actions:
                log: true
            - id: 2
              name: Rule_2
              base_action: inspect
              match_criterias:
                source_ip_prefix: 10.0.0.0/12
                source_fqdn: cisco.com
                destination_ip_prefix: 10.0.0.0/12
                destination_fqdn: cisco.com
                local_application_list: ZBFW_LAL_1_uni1
            - id: 3
              name: Rule_3
              base_action: drop
              match_criterias:
                source_ip_prefix_variable: sipprfxvar1
                destination_ip_prefix_variable: dipprfxvar1
              actions:
                log: true
            - id: 4
              name: Rule_4
              base_action: inspect
              match_criterias:
                protocols:
                  - 6
                  - 17
          zone_pairs:
            - source_zone: Test_zone_1
              destination_zone: Test_zone_2
            - source_zone: Test_zone_3
              destination_zone: Test_zone_4
        - name: Test_zone_based_firewall_2
          description: Test_zone_based_firewall_2
          default_action_type: drop
          rules:
            - id: 1
              name: Rule_set_1
              base_action: inspect
              match_criterias:
                source_data_prefix_lists:
                  - ZBFW_SDPL_1
                  - ZBFW_SDPL_2
            - id: 2
              name: Rule_2
              base_action: drop
          zone_pairs:
            - source_zone: self_zone
              destination_zone: Test_zone_2
```
