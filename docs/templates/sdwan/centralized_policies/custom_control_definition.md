# Custom Control Definition

Custom Control Policy Definition define the matching conditions and Actions for Route and TLOC type filters

{{ doc_gen }}

### Examples

```yaml
sdwan:
  centralized_policies:
    definitions:
      control_policy:
        custom_control_topology:
          - name: CCT_DEFINITION_TEST1
            description: CCT_DEFINITION_TEST1
            default_action_type: accept
            sequences:
              - id: 1
                base_action: accept
                name: rule1
                ip_type: ipv4
                type: route
                match_criterias:
                  color_list: COLOR-INTERNET-CCT-TEST
                  community_list: COMMUNITY-REGION-CCT-TEST
                  omp_tag: 65
                  expanded_community_list: EXP-COMMUNITY-CCT-TEST
                  preference: 45
                  originator: 10.10.20.30
                  site_list: TEXAS-CCT-TEST
                  path_type: direct-path
                  vpn_list: VPN-LIST-CCT-TEST1
                  ipv4_prefix_list: PREFIX-LIST-CCT-TEST
                  tloc:
                    ip: 10.10.33.67
                    color: custom1
                    encap: ipsec
                actions:
                  community: 100:1000
                  community_additive: true
                  preference: 48
                  omp_tag: 88
                  tloc:
                    ip: 1.2.5.9
                    color: custom2
                    encap: ipsec
                  export_to_vpn_list: VPN-LIST-CCT-TEST2
              - base_action: reject
                id: 2
                name: rule2
                ip_type: ipv4
                type: tloc
                match_criterias:
                  carrier: carrier1
                  color_list: COLOR-INTERNET-CCT-TEST2
                  domain_id: 567
                  group_id: 678
                  omp_tag: 77
                  originator: 12.13.14.15
                  preference: 88
                  site_list: TEXAS-CCT-TEST
                  tloc:
                    ip: 10.10.33.67
                    color: custom1
                    encap: ipsec
                actions:
                  omp_tag: 89
                  preference: 49
```
