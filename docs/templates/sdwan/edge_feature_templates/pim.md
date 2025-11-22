# Edge PIM Feature Template

The SD-WAN PIM feature template enables scalable multicast routing across the SD-WAN fabric by integrating Protocol Independent Multicast (PIM) configuration within customer VPNs. It supports both PIM Sparse Mode (PIM-SM) and Source-Specific Multicast (PIM-SSM), allowing for flexible RP (Rendezvous Point) management using Auto-RP or BSR mechanisms. The template facilitates efficient multicast group distribution, secure overlay tree construction, and native multicast extension with IGMPv2 and IGMPv3 support, ensuring optimized and reliable multicast delivery throughout the SD-WAN environment.

{{ doc_gen }}

### Examples

Example-1: This example demonstrates a cEdge PIM feature template configured with Auto RP enabled. It specifies supported device types, sets up PIM interfaces, and defines RP addresses and candidates using Loopback511. 
The template includes RP announces and RP discovery settings, as well as SPT threshold and SSM access-list configuration. This setup enables automated RP management and multicast group distribution for the listed devices within the SD-WAN fabric.

```yaml
sdwan:
  edge_feature_templates:
    pim_templates:
      - name: FT-CEDGE-PIM-01
        description: The cEdge PIM Feature Template with Auto RP and RP announces and discovery included
        device_types:
          - C8000V
          - C8200-1N-4T
          - C8200L-1N-4T
          - C8300-1N1S-4T2X
          - C8300-1N1S-6T
          - C8300-2N2S-4T2X
          - C8300-2N2S-6T
          - C8500-12X
          - C8500-12X4QC
          - C8500-20X6C
          - C8500L-8S4X
        auto_rp: true
        interfaces:
          - interface_name: Loopback511
            join_prune_interval: 60
            query_interval: 30
        rp_addresses:
          - ip_address: 10.0.0.2
            access_list: "27"
            override: false
        rp_candidates:
          - interface_name: Loopback511
        rp_announces:
          - interface_name: Loopback511
            scope: 1
        rp_discovery_interface: Loopback511
        rp_discovery_scope: 1
        spt_threshold: "0"
        ssm_access_list_range: "27"
        ssm_default: True
```
Example-2: This example illustrates a cEdge PIM feature template configured with Auto RP disabled and BSR (Bootstrap Router) enabled. It specifies the supported device type, sets up the BSR candidate interface and related parameters, and defines PIM interfaces, RP addresses, and RP candidates using GigabitEthernet6. 
The template includes SPT threshold and SSM access-list configuration, enabling multicast group management and RP election through BSR for the device within the SD-WAN fabric.

```yaml
sdwan:
  edge_feature_templates:
    pim_templates:
      - name: FT-CEDGE-PIM-02
        description: The cEdge PIM Feature Template with no auto RP and BSR included
        device_types:
          - C8000V
        auto_rp: false
        bsr_candidate_interface: GigabitEthernet6
        bsr_candidate_hash_mask_length: 32
        bsr_candidate_priority: 1
        bsr_candidate_rp_access_list: "10"
        interfaces:
          - interface_name: GigabitEthernet6
            join_prune_interval: 60
            query_interval: 30
        rp_addresses:
          - ip_address: 10.0.0.1
            access_list: "10"
            override: false
        rp_candidates:
          - interface_name: GigabitEthernet6
            access_list: "10"
            priority: 2
            interval: 100
        spt_threshold: "0"
        ssm_access_list_range: "10"
        ssm_default: True
```
