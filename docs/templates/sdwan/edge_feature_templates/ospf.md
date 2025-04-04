# OSPF Feature Template

Configure the OSPF Routing parameters for a IOS-XE WAN Edge. This feature tempalte is referenced under a VPN feature template in the cEdge Device Template.
OSPF routing allows the WAN Edge to make intelligent routing decision. 

{{ doc_gen }}

### Examples

Examples-1: OSPF template with MD5 authentication, with variable for MD5 password, variable for interfaces, variable for route policy and variable for router-id. This template allows OMP routes to be redistributed into OSPF, this is will allow service side devices to learn routes from OMP routes. Enable OSPF MD5 authentication for added security.

```yaml
sdwan:
  edge_feature_templates:
    ospf_templates:
      - name: FT-CEDGE-OSPF-01
        description: "OSPF base template"
        areas:
          - area_number: 0
            interfaces:
              - authentication_message_digest_key_variable: ospf_area0_if_md5_key
                authentication_message_digest_key_id: 1
                authentication_type: message-digest
                name_variable: ospf_area0_if_name
                passive_interface: false
        default_information_originate: true
        redistributes:
          - protocol: omp
            route_policy_variable: ospf_redistribute_omp_route_policy
        router_id_variable: ospf_router_id
```

Examples-2: OSPF template with MD5 authentication, with variable for MD5 password, variable for interfaces, variable for route policy and variable for router-id. This template allows OMP routes to be redistributed into OSPF, this will allow service side devices to learn routes from static routes defined on the WAN Edge. Enable OSPF MD5 authentication for added security. OSPF timers have added to tweak the failover and convergence times.


```
sdwan:
  edge_feature_templates:
    ospf_templates:
      - name: XXX_Service-InternalVPN-OSPF_v001
        description: Service Side Internal VPN OSPF Template
        device_types:
          - C8000V
          - ISR-4331
        areas:
          - area_number_variable: VPNx_ospf_area_number_var
            interfaces:
              - authentication_message_digest_key: password
                authentication_message_digest_key_id: 1
                authentication_type: message-digest
                cost: 1
                dead_interval: 20
                hello_interval: 5
                name_variable: VPNx_ospf_interface_var
        default_information_originate_metric: 100
        default_information_originate_metric_type: type1
        router_id_variable: VPNx_router_ospf_id_var
        redistributes:
          - protocol: static
```
