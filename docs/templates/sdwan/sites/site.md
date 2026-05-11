# Site

This includes site and device specific configuration including device variables.

{{ doc_gen }}

### Examples

Example-1: The example below shows how to assign router to a single device configuration group, list variables for device-specific fields in features under this configuration group and specify configuration should not be deployed to the device. This also include association of policy group with policy variables.

```yaml
sdwan:
  sites:
    - id: 1
      routers:
        - chassis_id: C8K-3D1A8960-6E76-532C-DA93-50626FC5797E
          configuration_group: branch_type1
          configuration_group_deploy: false
          policy_group: emea_branches
          policy_group_deploy: false
          device_variables:
            system_ip: 10.0.0.1
            site_id: 1
            host_name: Edge1
            pseudo_commit_timer: 300
            vpn0_inet_ip: 172.16.1.1
            vpn0_inet_mask: 255.255.255.0
            vpn0_inet_sec1_ip: 172.16.1.191
            vpn0_inet_sec1_mask: 255.255.255.0
            vpn0_inet_ipv6: 2001:db8::1/64
            vpn0_ipv6_sec1_ip: 2001:db8:1::1/64
            motd_banner: this is motd banner
            device_access_destination_prefixes:
              - 10.0.0.0/8
              - 172.16.0.0/12
            device_access_source_prefixes:
              - 10.0.0.0/8
              - 172.16.0.0/12
            vpn512_mgmt_int_ip: 192.168.254.1
            vpn512_mgmt_int_mask: 255.255.255.0
            vpn512_mgmt_int_ipv6: fd02::1/64
          policy_variables:
            target_qos_interfaces:
              - GigabitEthernet1
              - GigabitEthernet2
```

Example-2: The example below shows how to assign router to a dual device configuration group in SD-WAN version 20.15, assign the tag required for dual device configuration group, list variables for device-specific fields in features under this configuration group and specify configuration should be deployed to the device.

```yaml
sdwan:
  sites:
    - id: 1
      routers:
        - chassis_id: C8K-3D1A8960-6E76-532C-DA93-50626FC5797E
          configuration_group: branch_type2
          configuration_group_deploy: true
          tags:
            - primary_router
          device_variables:
            system_ip: 10.0.0.1
            site_id: 1
            host_name: Edge1
            pseudo_commit_timer: 300
            vpn0_inet_ip: 172.16.1.1
            vpn0_inet_mask: 255.255.255.0
            vpn0_inet_sec1_ip: 172.16.1.191
            vpn0_inet_sec1_mask: 255.255.255.0
            vpn0_inet_ipv6: 2001:db8::1/64
            vpn0_ipv6_sec1_ip: 2001:db8:1::1/64
            motd_banner: this is motd banner
            device_access_destination_prefixes:
              - 10.0.0.0/8
              - 172.16.0.0/12
            device_access_source_prefixes:
              - 10.0.0.0/8
              - 172.16.0.0/12
            vpn512_mgmt_int_ip: 192.168.254.1
            vpn512_mgmt_int_mask: 255.255.255.0
            vpn512_mgmt_int_ipv6: fd02::1/64
```

Example-3: The example below shows how to assign router to a dual device configuration group in SD-WAN version 20.18 and higher, assign the topology label required for dual device configuration group, list variables for device-specific fields in features under this configuration group and specify configuration should be deployed to the device.

```yaml
sdwan:
  sites:
    - id: 1
      routers:
        - chassis_id: C8K-3D1A8960-6E76-532C-DA93-50626FC5797E
          configuration_group: branch_type2
          configuration_group_deploy: true
          topology_label: primary_router
          device_variables:
            system_ip: 10.0.0.1
            site_id: 1
            host_name: Edge1
            pseudo_commit_timer: 300
            vpn0_inet_ip: 172.16.1.1
            vpn0_inet_mask: 255.255.255.0
            vpn0_inet_sec1_ip: 172.16.1.191
            vpn0_inet_sec1_mask: 255.255.255.0
            vpn0_inet_ipv6: 2001:db8::1/64
            vpn0_ipv6_sec1_ip: 2001:db8:1::1/64
            motd_banner: this is motd banner
            device_access_destination_prefixes:
              - 10.0.0.0/8
              - 172.16.0.0/12
            device_access_source_prefixes:
              - 10.0.0.0/8
              - 172.16.0.0/12
            vpn512_mgmt_int_ip: 192.168.254.1
            vpn512_mgmt_int_mask: 255.255.255.0
            vpn512_mgmt_int_ipv6: fd02::1/64
```

Example-4: The example below shows how to assign router to a device template and list all the variables required for template assignement.

!!! info
For variables under Security Policies, they are defined a bit differently with a `vedgePolicy/` prefix. For example, a variable named `zbfw_dip_pl_1` in security policy will be defined as `vedgePolicy/zbfw_dip_pl_1`

```yaml
sdwan:
  sites:
    - id: 2101
      routers:
        - chassis_id: C8K-CC678D1C-8EDF-3966-4F51-ABFAB64F5ABE
          model: C8000V
          device_template: DT-C8000V-TEST
          device_variables:
            site_id: 2101
            system_ip: 10.0.2.101
            system_hostname: SITE2101-C8KV-01
            logging_server_source_interface: Loopback511
            ntp_server_source_interface: Loopback511
            global_cdp_enable: true
            global_lldp_enable: false
            global_ip_domain_lookup_enable: true
            snmp_shutdown: false
            snmp_trap_source_interface: Loopback511
            snmp_contact: contact@acme.com
            snmp_location: Location 2101
            system_location: Site2101
            system_description: Site 2101 C8KV01
            timezone: UTC
            system_latitude: 38.1
            system_longitude: -1.9
            ondemand_tunnel_enable: false
            ondemand_tunnel_idle_timeout: 10
            vpn0_layer4_ecmp_enable: true
            vpn0_tloc01_if_name: GigabitEthernet1
            vpn0_tloc01_if_description: INET-1
            vpn0_tloc01_if_shutdown: false
            vpn0_tloc01_shaping_rate: 1000000
            vedgePolicy/zbfw_dip_pl_1: 10.10.99.0/24
```

Example-5: The example below shows how to use the `management_ip_variable` field for direct-to-device (D2D) testing. This field specifies which device variable contains the management IP address for SSH connectivity. The global setting at the `sdwan` level applies to all devices, while a per-router setting overrides the global default.

```yaml
sdwan:
  # Global management_ip_variable - applies to all devices (2nd preference)
  management_ip_variable: "vpn10_Lo10_if_ipv4_address"
  sites:
    - id: 100
      routers:
        # This router uses the global management_ip_variable
        - chassis_id: C8K-AAA11111-1111-1111-1111-111111111111
          configuration_group: branch_type1
          device_variables:
            system_ip: 10.0.0.1
            vpn10_Lo10_if_ipv4_address: 10.1.1.1/32

        # This router overrides with its own management_ip_variable (1st preference)
        - chassis_id: C8K-BBB22222-2222-2222-2222-222222222222
          configuration_group: branch_type1
          management_ip_variable: "vpn512_mgmt_ip"
          device_variables:
            system_ip: 10.0.0.2
            vpn10_Lo10_if_ipv4_address: 10.1.1.2/32
            vpn512_mgmt_ip: 192.168.1.100/24
```

!!! note
    The `management_ip_variable` field is used by the `nac-test` [testing framework](https://github.com/netascode/nac-test) to determine which IP address to use for SSH connections during direct-to-device (D2D) tests. The referenced variable must exist in the router's `device_variables` and contain a valid IPv4 address (with or without CIDR notation).
