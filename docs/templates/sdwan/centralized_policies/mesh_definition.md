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
          - name: Test_mesh_number1
            description: Test_mesh_number1
            vpn_list: vpnlistblr
            mesh_groups:
              - name: region1
                site_lists:
                  - texas
                  - blr
              - name: region3
                site_lists:
                  - mexico
                  - canada
          - name: Test_mesh_number2
            description: Test_mesh_number2
            vpn_list: vpn_list_mum
            mesh_groups:
              - name: region8
                site_lists:
                  - sitelist9
                  - sitelist10
```                   
