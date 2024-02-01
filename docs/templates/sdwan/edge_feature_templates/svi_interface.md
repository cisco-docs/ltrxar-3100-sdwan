# Edge VPN Interface SVI Feature Template

Configure an interface name, the status of the interface, static IPv4 and v6 addressing, DHCP helper, VRRP, ingress/egress access control list (ACL) for IPv4 and 6, static Address Resolution Protocol (ARP), IP maximum transmission unit (MTU), Transmission Control Protocol maximum segment size (TCP MSS) and more.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  edge_feature_templates:
    svi_interface_templates:
      - name: FT-CEDGE-VPN10-SVI1
        description: "EDGE SVI Interface"
        interface_description_variable: vpn10_svi1_if_description
        interface_name_variable: vpn10_svi1_if_name
        ipv4_address_variable: vpn10_svi1_ipv4_address
        ipv4_ingress_access_list: QOS_ACL_IN
        ipv4_vrrp_groups:
          - address_variable: vpn10_svi1_vrrp_ip
            id: 10
            priority_variable: vpn10_svi1_vrrp_priority
            timer: 1000
            track_omp: true
```
