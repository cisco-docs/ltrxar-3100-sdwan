# Mesh Topology Definition

Mesh is one type of topology in which each of the device is allowed to send and receive data traffic to any other device.

Mesh Topology Definition define the mesh sites that should create the mesh connections between them.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  centralized_policies:
    definitions:
      control_policy:
        mesh_topology:
          - name: MT_DEFINITION_TEST1
            description: MT_DEFINITION_TEST1
            vpn_list: VPN-LIST-MT-TEST1
            mesh_groups:
              - name: MESH-REGION-TEST1
                site_lists:
                  - PHOENIX-MT-TEST
                  - HOSUTON-MT-TEST
              - name: MESH-REGION-TEST2
                site_lists:
                  - MADISON-MT-TEST
                  - KANSAS-MT-TEST
```                   
