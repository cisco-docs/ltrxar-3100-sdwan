# Service LAN VPN SVI Interface Feature

Configure LAN VPN SVI interface feature.

{{ doc_gen }}

### Examples

Example-1: The example below demonstrates how to configure a service SVI interface feature under LAN VPN feature within a service profile with static IPv4 and IPv6 address settings. The interface is configured with VRRP high availability for both IPv4 and IPv6 address families, including tracking objects for failover scenarios.

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: service2
        lan_vpns:
          - name: service_lan_vpn1
            description: Branch LAN VPN 
            vpn_id: 1
            vpn_name: VPN1
            svi_interfaces:
            - name: lan_interface_svi1
              description: Service LAN VPN Interface SVI
              interface_description: Full SVI Interface
              interface_name: Vlan1
              ipv4_address: 10.0.2.1
              ipv4_subnet_mask: 255.255.255.0
              ipv4_vrrp_groups:
                - address: 10.0.2.31
                  id: 10
                  priority: 120
                  timer: 1000
                  tracking_objects:
                    - action: decrement
                      tracker_object: object_route_tracker
                      decrement_value: 20
              ipv6_address: 2001:db9::1/64
              ipv6_vrrp_groups:
                - addresses:
                    - link_local_address: fe80::1
                      global_prefix: 2001:db9::ffff/64
                  id: 20
                  priority: 120
                  timer: 1000
              shutdown: false
```
