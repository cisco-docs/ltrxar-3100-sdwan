# Service DHCP Server Feature

Configure DHCP Server feature.

{{ doc_gen }}

### Examples

Example-1: DHCP Server Configuration for Guest Wi-Fi and Employee LAN Segments

A retail organization operates a branch office where network administrators need to assign IP addresses dynamically to two separate LAN segments: one for employees and another for guest Wi-Fi users. Each segment operates on a different VPN (VPN 20 for employees and VPN 30 for guests). The employee LAN requires IP reservation for specific devices such as printers and POS systems, while the guest Wi-Fi segment demands basic DHCP settings with a strict exclusion of specific IP ranges for security. The DHCP configuration ensures clients in both segments automatically receive network settings like IP address, gateway, DNS, and domain information. Additionally, custom DHCP options are included for specialized services used in the guest segment.

This YAML configuration defines two DHCP server profiles under feature_profiles → service_profiles to serve different VPN segments in an SD-WAN deployment. The first profile, DHCP-EMPLOYEE-LAN, configures a DHCP server for VPN 20 with a /24 subnet, setting default gateway, DNS servers, and reserving IPs for critical employee devices like printers and POS terminals. The second profile, DHCP-GUEST-WIFI, defines a DHCP server for VPN 30 using a /25 subnet, with a limited lease time to restrict guest usage and explicit exclusion of sensitive IP addresses for security. Additionally, custom DHCP options are added using code and hex to support specific guest service requirements. This configuration ensures robust, segmented, and automated IP management across the enterprise LAN.

```yaml
sdwan:
  feature_profiles:
    service_profiles:
      - name: DHCP-EMPLOYEE-LAN
        description: DHCP Server for Employee LAN on VPN 20
        dhcp_servers:
          - name: DHCP-Employee
            description: Employee LAN DHCP on VPN 20
            pool_network_address_variable: vpn20_dhcp_pool
            pool_subnet_mask: "255.255.255.0"
            default_gateway_variable: vpn20_gateway
            dns_servers:
              - 8.8.8.8
              - 1.1.1.1
            domain_name: "corp.local"
            lease_time: 86400
            exclude_addresses:
              - 192.168.20.1
              - 192.168.20.200-192.168.20.210
            static_leases:
              - mac_address_variable: printer_mac
                ip_address_variable: printer_ip
              - mac_address_variable: pos_mac
                ip_address_variable: pos_ip

      - name: DHCP-GUEST-WIFI
        description: DHCP Server for Guest Wi-Fi on VPN 30
        dhcp_servers:
          - name: DHCP-Guest
            description: Guest Wi-Fi DHCP on VPN 30
            pool_network_address_variable: vpn30_dhcp_pool
            pool_subnet_mask: "255.255.255.128"
            default_gateway_variable: vpn30_gateway
            dns_servers:
              - 9.9.9.9
              - 4.2.2.2
            domain_name: "guest.local"
            lease_time: 3600
            exclude_addresses:
              - 192.168.30.1-192.168.30.10
            options:
              - code: 60
                hex: "0102030405"
```

Example-2: Edge LAN profile basic DHCP Server

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

Example-3: Edge LAN profile basic DHCP Server - domain name, lease time

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
