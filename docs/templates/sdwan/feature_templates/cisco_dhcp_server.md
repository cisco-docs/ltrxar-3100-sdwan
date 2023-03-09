# Cisco DHCP Server Feature Template

Configure DHCP server characteristics, such as address pool, lease time, static leases, domain name, default gateway, DNS servers, and TFTP servers.

{{ sdwan_doc }}

### Examples

```yaml
sdwan:
  cedge_feature_templates:
    cisco_dhcp_server:
      - name: FT-CEDGE-DHCPSERVER-VPN2-V01
        description: Internet DHCP Server
        parameters:
          address-pool: DEVICE_VARIABLE;vpn2_dhcp_address_pool
          exclude: DEVICE_VARIABLE;vpn2_dhcp_exclude_addresses
          lease-time: 3600
          options:
            default-gateway: DEVICE_VARIABLE;vpn2_dhcp_default_gateway
            dns-servers: DEVICE_VARIABLE;vpn2_dhcp_dns_servers
```
