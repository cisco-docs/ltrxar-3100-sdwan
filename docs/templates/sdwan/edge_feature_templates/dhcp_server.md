# DHCP Server Feature Template

Configure DHCP server characteristics, such as address pool, lease time, static leases, domain name, default gateway, DNS servers, and TFTP servers.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  edge_feature_templates:
    dhcp_server_templates:
      - name: FT-CEDGE-DHCPSERVER-VPN2-V01
        description: Internet DHCP Server
        address_pool_variable: vpn2_dhcp_address_pool
        exclude_addresses_variable: vpn2_dhcp_exclude_addresses
        lease_time: 3600
        default_gateway_variable: vpn2_dhcp_default_gateway
        dns_servers:
          - 1.1.1.1
          - 1.0.0.1
```
