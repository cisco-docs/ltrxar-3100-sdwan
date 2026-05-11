# Service LAN VPN Ethernet Interface Feature

Configure LAN VPN Ethernet interface feature. 

{{ doc_gen }}

### Examples

Example-1: The example below demonstrates how to configure a service ethernet interface feature under LAN VPN feature within a service profile with static IPv4 and IPv6 address settings. The interface is configured with VRRP high availability for both IPv4 and IPv6 address families, including tracking object for failover scenarios.

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: branch-lan-vpn20
        description: Branch LAN VPN 20 with High Availability
        lan_vpns:
          - name: branch-lan-vpn20
            description: Branch LAN VPN for internal users with VRRP redundancy
            vpn_id: 20
            vpn_name: vpn20-lan
            ethernet_interfaces:
              - name: lan_int_static
                interface_name: GigabitEthernet0/0/1
                interface_description: "Branch LAN Interface with VRRP HA"
                shutdown: false
                ipv4_address_type: static
                ipv4_address: 192.168.20.2
                ipv4_subnet_mask: 255.255.255.0                
                ipv4_vrrp_groups:
                  - id: 1
                    address: 192.168.20.1
                    priority: 110
                    timer: 1000
                    tracking_objects:
                      - tracker_object: tracker_obj1
                        action: Decrement
                        decrement_value: 50
                ipv6_address_type: static
                ipv6_address: 2001:db8:20::2/64
                ipv6_vrrp_groups:
                  - id: 1
                    link_local_address: fe80::1
                    global_prefix: 2001:db8:20::1/64
                    priority: 110
                    timer: 1000
```

Example-2: The example below demonstrates how to configure a LAN VPN ethernet interface feature within a service profile with dynamic IPv4 and IPv6 address settings.

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: branch-lan-vpn30
        description: Branch LAN VPN 30  
        lan_vpns:
          - name: branch-lan-vpn30
            vpn_id: 30
            vpn_name: vpn30-lan
            ethernet_interfaces:
              - name: lan_int_dynamic
                interface_name: GigabitEthernet0/0/2
                interface_description: "DHCP Client Interface"
                ipv4_address_type: dynamic
                ipv4_dhcp_distance: 1
                ipv6_address_type: dynamic
```