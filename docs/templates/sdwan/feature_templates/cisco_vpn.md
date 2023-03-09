# Cisco VPN Feature Template

Change the ECMP hash, add DNS servers, advertise protocols (BGP, static, connected, OSPF external) from the VPN into OMP, and add IPv4 or v6 static routes, service routes, and GRE routes.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  cedge_feature_templates:
    cisco_vpn:
      - name: FT-CEDGE-VPN0-01
        description: "CEDGE VPN0 with static IP settings"
        parameters:
          dns:
            - dns-addr: DEVICE_VARIABLE;vpn0_dns_primary
              role: primary
            - dns-addr: DEVICE_VARIABLE;vpn0_dns_secondary
              role: secondary
          ecmp-hash-key:
            layer4: DEVICE_VARIABLE;vpn0_layer4_ecmp_enable
          ip:
            route:
              - next-hop:
                  - address: DEVICE_VARIABLE;vpn0_ipv4_route1_nexthop1_ip
                    distance: DEVICE_VARIABLE;vpn0_ipv4_route1_nexthop1_distance
                prefix: DEVICE_VARIABLE;vpn0_ipv4_route1_prefix
                optional: false
          name: VPN0
          vpn-id: 0
```
