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
          - name: Test_control_number1
            description: Test_control_number1
            default_action_type: accept
            sequences:
              - base_action: accept
                id: 1
                name: 1strule
                ip_type: ipv4
                type: tloc
                match_criterias:
                  - color_list: bglcolorgroup1
                  - site_list: bglsites
                actions:
                  - set_parameters:
                      - omp_tag: 789053
              - base_action: reject
                id: 2
                name: rule2
                ip_type: ipv4
                type: route
                match_criterias:
                  - originator: 6.78.98.7
                  - tloc:
                      ip: 1.2.3.4
                      color: 3g
                      encap: ipsec
                actions:
                  - set_parameters:
                      - tloc:
                          ip: 1.2.3.4
                          color: 3g
                          encap: ipsec
                      - service:
                          type: FW
                          vpn: 3
                          tloc:
                            ip: 1.2.3.4
                            color: 3g
                            encap: ipsec
                  - export_to_parameter:
                      vpn_list: vpnlisttexas
```
