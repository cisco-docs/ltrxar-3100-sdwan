# OSPF Feature Template

Configure the OSPF Routing parameters for a IOS-XE WAN Edge. This feature tempalte is referenced under a VPN feature template in the cEdge Device Template.

{{ doc_gen }}

### Examples

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
