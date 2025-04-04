# VPN Interface SVI Feature Template

The below example configures a global vpn 10 SVI template.

{{ doc_gen }}

### Examples

Example-1 : In the following example , VPN10 SVI interface will be configured , which would define interface name , description and ipv4 address.
There is also a reference to already defined ACL in the inbound direction and global dhcp helpers.
Lastly , VRRP has been configured to complete the configuration of SVI interface.

```yaml
sdwan:
  edge_feature_templates:
    svi_interface_templates:
      - name: GLOBAL-SVI1-VPN10-INTF
        description: "VPN10-SVI-INTF"
        interface_description_variable: vpn10_svi1_if_description
        interface_name_variable: vpn10_svi1_if_name
        ipv4_address_variable: vpn10_svi1_ipv4_address
        ipv4_ingress_access_list: QOS_ACL_IN
        shutdown: false
        ipv4_dhcp_helpers:
          - 10.10.10.4
          - 10.10.10.5
        ipv4_vrrp_groups:
          - address_variable: vpn10_svi1_ipv4_vrrp_ip
            id: 1
            optional: false
            priority_variable: vpn10_svi1_ipv4_vrrp_priority
            secondary_addresses:
              - address_variable: abcd
            timer: 1000
            track_prefix_list: abcd
            track_omp: false
            tracking_objects:
              - action: decrement
                decrement_value: 3
                id: 1
```
