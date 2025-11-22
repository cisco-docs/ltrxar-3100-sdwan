# DHCP Server Feature Template

Configure DHCP server characteristics, such as address pool, lease time, static leases, domain name, default gateway, DNS servers, and TFTP servers.

{{ doc_gen }}

### Examples

Example-1: The example below illustrates how to configure DHCP server feature template. It defines the address pool, default gateway and DNS server addresses, providing essential network settings to connected devices. Additionally, it includes exclusion of specific addresses from the DHCP pool, configures lease time, and optionally sets up static address leases with specific IP and MAC addresses.

```yaml
sdwan:
  edge_feature_templates:
    dhcp_server_templates:
      - name: FT-EDGE-VPN11-DHCP-LAN-V01
        description: Guest VPN DHCP Server
        address_pool_variable: vpn11_ipv4_lan_dhcp_address_pool
        exclude_addresses_variable: vpn11_ipv4_lan_dhcp_exclude_addresses
        lease_time: 3600
        static_leases:
          - ip_address_variable: vpn11_ipv4_lan_dhcp_static_addresses
            mac_address_variable: vpn11_ipv4_lan_dhcp_static_mac
            optional: true
        default_gateway_variable: vpn11_ipv4_lan_dhcp_default_gateway
        dns_servers_variable: vpn11_ipv4_lan_dhcp_dns_servers
```
