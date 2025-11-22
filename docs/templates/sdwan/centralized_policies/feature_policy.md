# Policy

Centralized policy can be built by either feature policy or cli policy.The focus for this example is feature policy.
Centralized policy comprises of control policies , data policies and references to policy objects which is applied to all the sites.Only one centralized policy can be activated at any given instant.

{{ doc_gen }}

### Examples

Example-1 : In the following example , the name of centralized policy has been configured as CP-Hub-and-Spoke-01 and is stitched together using following policies :

1.control policies.

  TOPOLOGY-DC-OUT-01 which is applied to sites defined in site list CENTRAL-DC in the out direction
  TOPOLOGY-BR-T1-01 which is applied to sites defined in site list BR-T1 in the out direction
  TOPOLOGY-BR-T2-01 which is applied to sites defined in site list BR-T2 in the out direction

2.traffic data policies 

  DP-VPN10-01 which is applied to sites defined in site list CENTRAL-DC and BR-ALL for VPN list defined in VPN-PROD.
  DP-VPN11-01 which is applied to sites defined in site list CENTRAL-DC and BR-ALL for VPN list defined in VPN-Guest.

3.application aware routing

  AAR-Policy-01 is applied to sites defined in site list CENTRAL-DC and BR-ALL for VPN list defined in VPN-PROD.
  
4.cflowd policy 
 
  CFLOW_DEFINITION_v01 is applied to sites defined in site list DC-BR-ALL

```yaml
sdwan:
  centralized_policies:
    feature_policies:
      - name: CP-Hub-and-Spoke-01
        description: Hub and Spoke | AAR | DP for QoS | cFlow
        custom_control_topology:
          - policy_definition: TOPOLOGY-DC-OUT-01
            site_region:
              site_lists_out:
                - CENTRAL-DC
          - policy_definition: TOPOLOGY-BR-T1-01
            site_region:
              site_lists_out:
                - BR-T1     
          - policy_definition: TOPOLOGY-BR-T2-01
            site_region:
              site_lists_out:
                - BR-T2   
        traffic_data:
          - policy_definition: DP-VPN10-01
            site_region_vpn:
              - direction: service
                site_lists:
                  - CENTRAL-DC
                  - BR-ALL
                vpn_lists:
                  - VPN-PROD
          - policy_definition: DP-VPN11-01
            site_region_vpn:
              - direction: service
                site_lists:
                  - CENTRAL-DC
                  - BR-ALL
                vpn_lists:
                  - VPN-Guest
        application_aware_routing:
          - policy_definition: AAR-Policy-01
            site_region_vpn:
              site_lists:
                - CENTRAL-DC
                - BR-ALL
              vpn_lists:
                - VPN-PROD
        cflowd:
          - policy_definition: CFLOW_DEFINITION_v01
            site_lists:
              - DC-BR-ALL
```                   
