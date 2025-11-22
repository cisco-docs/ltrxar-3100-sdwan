# Edge Multicast Feature Template

The SD-WAN multicast overlay extends PIM-SSM across the SD-WAN using OMP, integrating PIM in customer VPNs with overlay multicast management. This implementation creates a secure, optimized multicast tree over the SD-WAN overlay, supporting IGMPv2 and IGMPv3 for efficient native multicast extension.

{{ doc_gen }}

### Examples

Example-1: The following example demonstrates how to configure a multicast configuration across supported Catalyst SD-WAN edge devices. 
It enables local replicator functionality to improve multicast efficiency and sets a threshold limit of 20 to control multicast behavior within the network.

```yaml
sdwan:
  edge_feature_templates:
    multicast_templates:
      - name: FT-CEDGE-MULTICAST-01
        description: Base Multicast template
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
        local_replicator: true
        threshold: 20
```
Example-2: The following example demonstrates how to configure a multicast configuration across supported Catalyst SD-WAN edge devices. 
It enables local replicator functionality to improve multicast efficiency and sets a local and threshold limit using variable to control multicast behavior within the network.

```yaml
sdwan:
  edge_feature_templates:
    multicast_templates:
      - name: FT-CEDGE-MULTICAST-02
        description: Multicast template with the variables
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
        spt_only: true
        local_replicator_variable: vpn1_multicast_02_local
        threshold_variable: vpn1_multicast_02_threshold
```
