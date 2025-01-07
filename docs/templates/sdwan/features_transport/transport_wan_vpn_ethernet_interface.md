# Transport WAN VPN Ethernet Interface Feature

Configure WAN VPN (VPN 0) Ethernet interface and its' settings.

{{ doc_gen }}

### Examples

The example below demonstrates how to configure a ethernet interface feature under wan_vpn feature within a transport profile with static ipv4 address settings. The interface is also configured to be an Internet TLOC and has tunnel interface option enabled with biz-internet color and preference 200.

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: transport1
        wan_vpn:
          name: management_vpn
          ethernet_interfaces:
            - name: inet_tloc
              interface_name: GigabitEthernet1
              ipv4_address_variable: vpn0_inet_ip
              ipv4_subnet_mask_variable: vpn0_inet_mask
              tunnel_interface:
                color: biz-internet
                ipsec_preference: 200
```
