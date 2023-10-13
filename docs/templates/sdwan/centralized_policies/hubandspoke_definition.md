# Hub and Spoke Topology Definition

hub-and-spoke is one type of topology in which one of the devices acts as a hub site that receives the data traffic from all the spoke, or branch, devices and then redirects the traffic to the proper destination.

Hub and Spoke Topology Definition define the hub and spoke sites that should create the connections between them.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  centralized_policies:
    definitions:
      control_policy:
        hub_and_spoke_topology:
          - name: Test_hubnspoke_number1
            description: Test_hubnspoke_number1
            vpn_list: vpn_list_texas
            hub_and_spoke_sites:
              - name: group1
                equal_preference: true
                advertise_tloc: false
                tloc_list: tloclist1
                spokes:
                  - site_list: sitelist1
                    hubs:
                      - site_list: sitelist2
                        ipv6_prefix_lists:
                          - pfxlist1
                      - site_list: sitelist3
                        ipv4_prefix_lists:
                          - pfxlist9
                  - site_list: sitelist66
                    hubs:
                      - site_list: sitelist44
                        ipv4_prefix_lists:
                          - pfxlist4
                        ipv6_prefix_lists:
                          - pfxlist6
              - name: group2
                equal_preference: false
                advertise_tloc: true
                tloc_list: tloclist2
                spokes:
                  - site_list: sitelist9
                    hubs:
                      - site_list: sitelist10
                      - site_list: sitelist11
                      - site_list: sitelist12
                      - site_list: sitelist13
                      - site_list: sitelist14
                        ipv4_prefix_lists:
                          - pfxlist44
                        ipv6_prefix_lists:
                          - pfxlist966
```                           
