# Service DHCP Server Feature

Configure DHCP Server feature.

{{ doc_gen }}

### Examples

The example below illustrates how to configure DHCP server feature within a service profile. It defines the address pool, setting the network address and subnet mask, as well as default gateway and DNS server addresses, providing essential network settings to connected devices. Additionally, it includes exclusion of specific addresses from the DHCP pool.

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: DHCP-SERVRER-LAN-10
        description: Edge LAN profile basic DHCP Server
        dhcp_servers:
          - name: DHCP-Server-1
            description: LAN DHCP Server VPN 10
            pool_network_address_variable: vpn10_dhcp_address_pool
            pool_subnet_mask: "255.255.255.0"
            default_gateway_variable: vpn10_dhcp_default_gateway
            dns_servers:
              - 1.1.1.1
              - 9.9.9.9
            domain_name: "test.com"
            lease_time: 60000
            exclude_addresses_variable: vpn10_dhcp_exclude_addresses_lan
```


The example below illustrates how to configure DHCP server feature within a service profile. The configuration specifies an address pool, subnet mask, default gateway, and DNS servers, ensuring devices receive necessary network configurations. Additionally, it includes settings for domain name, lease time, exclusion of certain addresses, and static leases for specific devices, along with custom DHCP options.

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: DHCP-SERVRER-LAN-11
        description: Edge LAN profile basic DHCP Server
        dhcp_servers:
          - name: DHCP-Server-2
            description: LAN DHCP Server VPN 11
            pool_network_address_variable: vpn11_dhcp_address_pool
            pool_subnet_mask: "255.255.255.128"
            default_gateway_variable: vpn11_dhcp_default_gateway
            dns_servers:
              - 1.1.1.1
              - 9.9.9.9
            domain_name: "test.com"
            lease_time: 60000
            exclude_addresses:
              - 10.10.10.100
              - 10.10.10.1-10.10.10.5
            static_leases:
              - mac_address_variable: vpn11_static_lease_mac1
                ip_address_variable: vpn11_static_lease_ip1            
            options:                
              - code: 43
                hex: "f305ac10011802" 
```