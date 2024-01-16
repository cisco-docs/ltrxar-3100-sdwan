# Policy

Policy combines one or more Centralized policy definitions to create a Policy. These policies can then be activated to be applied to the SD-WAN deployment.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  centralized_policies:
    feature_policies:
      - name: Super_policy_test2
        description: Super_policy_test2
        hub_and_spoke_topology:
          - policy_definition: HST_DEFINITION_TEST1
        mesh_topology:
          - policy_definition: MT_DEFINITION_TEST1
        vpn_membership:
          - policy_definition: VPN_DEFINITION_TEST1
        custom_control_topology:
          - policy_definition: CCT_DEFINITION_TEST1
            site_region:
              site_lists_in:
                - CHICAGO-CCT-TEST
              site_lists_out:
                - DENVER-CCT-TEST
                - ATLANTA-CCT-TEST
        traffic_data:
          - policy_definition: TD_DEFINITION_TEST1
            site_region_vpn:
              - direction: service
                site_lists:
                  - GOA-TD-TEST
                vpn_lists:
                  - VPN-LIST-TD-TEST1
              - direction: all
                site_lists:
                  - CHENNAI-TD-TEST
                vpn_lists:
                  - VPN-LIST-TD-TEST2
        cflowd:
          - policy_definition: CFLOW_DEFINITION_TEST2
            site_lists:
              - MY-CFLOW-TEST
        application_aware_routing:
          - policy_definition: Test_application_aware_routing_number2
            site_region_vpn:
              site_lists: 
                - CHENNAI-TD-TEST
              vpn_lists:
                - VPN-LIST-TD-TEST1
```                   
