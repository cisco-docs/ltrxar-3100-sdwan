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
          - name: HST_DEFINITION_TEST1
            description: HST_DEFINITION_TEST1
            vpn_list: VPN-LIST-HST-TEST1
            hub_and_spoke_sites:
              - name: group1
                equal_preference: true
                advertise_tloc: false
                tloc_list: TLOC-LIST-HST-TEST1
                spokes:
                  - site_list: CALIFORNIA-HST-TEST
                    hubs:
                      - site_list: BOSTON-HST-TEST
                      - site_list: NEWYORK-HST-TEST
                        ipv4_prefix_lists:
                          - PREFIX-LIST-HST-TEST
                  - site_list: WASHINGTON-HST-TEST
                    hubs:
                      - site_list: KENTUCKY-HST-TEST
              - name: group2
                equal_preference: true
                advertise_tloc: false        
                tloc_list: TLOC-LIST-HST-TEST2
                spokes:
                  - site_list: CALIFORNIA-HST-TEST
                    hubs:
                      - site_list: BOSTON-HST-TEST
                      - site_list: NEWYORK-HST-TEST
                        ipv4_prefix_lists:
                          - PREFIX-LIST-HST-TEST
                  - site_list: WASHINGTON-HST-TEST
                    hubs:
                      - site_list: KENTUCKY-HST-TEST
```                           
