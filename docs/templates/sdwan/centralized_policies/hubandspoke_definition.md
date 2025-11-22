# Hub and Spoke Topology Definition

hub-and-spoke is one type of topology in which one of the devices acts as a hub site that receives the data traffic from all the spoke, or branch, devices and then redirects the traffic to the proper destination.

Hub and Spoke Topology Definition define the hub and spoke sites that should create the connections between them.

{{ doc_gen }}

### Examples

Example-1: This example shows the configuration for a Hub and spoke Topology definition, containing a basic topology for VPN 1, it creates a topology where all the sites included into the site-list FRANKFURT-HUBS act as hubs and all the sites included into the site-list EMEA-BRANCHES act as spokes. This means, that all the EMEA-BRANCHES will create IPsec tunnels towards the FRANKFURT-HUBS only.

```yaml
sdwan:
  centralized_policies:
    definitions:
      control_policy:
        hub_and_spoke_topology:
          - name: EMEA_HUB_AND_SPOKE
            description: EMEA_HUB_AND_SPOKE_DESCRIPTION
            vpn_list: VPN1
              - name: EMEA
                equal_preference: true
                advertise_tloc: false
                spokes:
                  - site_list: EMEA-BRANCHES
                    hubs:
                      - site_list: FRANKFURT-HUBS
``` 

Example-2: This example shows the configuration for a Hub and spoke Topology definition, containing a complex topology for VPN 1, it creates a topology with two different rules for two different regions. For AMER region, it has two hubs (Boston and New York), where NewYork will be the hub only for the prefixes enumerated on the prefix list PREFER-NEWYORK-PREFIX-LIST, all the other AMER-BRANCHES will use Boston Hub. For EMEA Region, FRANKFURT-HUBS sites are considered as Hubs, and its preference is defined on EMEA-HUBS-TLOC-LIST, all the sites enumerated on EMEA-BRANCHES are considered as Spokes.

```yaml
sdwan:
  centralized_policies:
    definitions:
      control_policy:
        hub_and_spoke_topology:
          - name: GLOBAL_HUB_AND_SPOKE
            description: GLOBAL_HUB_AND_SPOKE_DEFINITION
            vpn_list: VPN1
            hub_and_spoke_sites:
              - name: AMER
                equal_preference: true
                advertise_tloc: false
                spokes:
                  - site_list: AMER-BRANCHES
                    hubs:
                      - site_list: BOSTON-HUBS
                      - site_list: NEWYORK-HUBS
                        ipv4_prefix_lists:
                          - PREFER-NEWYORK-PREFIX-LIST
                  - site_list: FLORIDA
                    hubs:
                      - site_list: MIAMI-HUB
              - name: EMEA
                equal_preference: true
                advertise_tloc: false        
                tloc_list: EMEA-HUBS-TLOC-LIST
                spokes:
                  - site_list: EMEA-BRANCHES
                    hubs:
                      - site_list: FRANKFURT-HUBS
```                           
