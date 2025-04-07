# Mesh Topology Definition

Mesh is one type of topology in which each of the device is allowed to send and receive data traffic to any other device.

Mesh Topology Definition define the mesh sites that should create the mesh connections between them.

{{ doc_gen }}

### Examples

Example-1: Mesh Topology for Secure Intra-VPN Communication

A customer operating a distributed enterprise network wants to ensure seamless and direct communication between branches without traffic hair-pinning through the data center. To achieve this, the customer defines a mesh topology under a centralized control policy for VPN 10, which connects all branch sites participating in shared services. This mesh topology will allow branch sites to dynamically form secure tunnels with each other, improving performance and reducing latency. The mesh group includes a site list representing the group of branches to be meshed together. This configuration enables secure, scalable, and resilient inter-site communication within the selected VPN.

The YAML defines a control policy that includes a mesh topology named BranchMeshTopology, tailored for VPN 10. The policy description outlines that it enables full mesh connectivity between all branches listed. It includes a single mesh group named BranchGroupMesh which aggregates branches defined under the site list BranchSites. This setup ensures that all the listed sites can directly establish IPsec tunnels with each other, eliminating dependency on hub sites and promoting high availability.

```yaml
sdwan:
  centralized_policies:
    definitions:
      control_policy:
        mesh_topology:
          - name: Global_Mesh
            description: Full mesh topology for inter-office communication
            vpn_list: VPN_10
            mesh_groups:
              - name: Global_Offices
                site_lists:
                  - New_York
                  - London
                  - Tokyo
```   
