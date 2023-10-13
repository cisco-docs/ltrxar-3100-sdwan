# Policy

Policy combines one or more Centralized policy definitions to create a Policy. These policies can then be activated to be applied to the SD-WAN deployment.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  centralized_policies:
    policies:
      - name: CP1
        description: CPI1 policy
        hub_and_spoke_topology:
          - policy_definition: Test_hubnspoke_number1
        mesh_topology:
          - policy_definition: Test_mesh_number2
        custom_control_topology:
          - policy_definition: Test_control_number1
            site_region_list:
              region_lists_in:
                - sitetexas
                - sitebgl
              region_lists_out:
                - siteshanghai
        vpn_membership:
          - policy_definition: Test_vpn_mem_number1
      - name: CP2
        description: CPI2 policy
        custom_control_topology:
          - policy_definition: newpolicyemea
            site_region_list:
              region_in: 4
              region_out: 5   
```                   
