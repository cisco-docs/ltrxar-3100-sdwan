# VPN Feature Template

The example below show the configuations of VPN template for transport and service

{{ doc_gen }}

### Examples

Example-1 : In the below example , VPN template for transport VPN is configured.
vpn_id should always be set 0 since its this template is applicable to transport side and variables are configured for two dns servers. There is a host-mapping for vbond which has been configured globally.
Static route is configured along with variables for nexthops.

```yaml
sdwan:
  edge_feature_templates:
    vpn_templates:
      - name: TRANSPORT_VPN
        description: Transport VPN Template
        ipv4_primary_dns_server_variable: vpn0_dns_primary
        ipv4_secondary_dns_server_variable: vpn0_dns_secondary
        vpn_name: TRANSPORT_VPN
        vpn_id: 0
        ipv4_dns_hosts:
          - hostname: vbond.cisco.com
            ips: 
              - 1.1.1.1
              - 2.2.2.2
        ipv4_static_routes:
          - prefix: 0.0.0.0/0
            optional: false
            next_hops:
              - address_variable: vpn0_ipv4_route1_nexthop1_ip
                distance_variable: vpn0_ipv4_route1_nexthop1_distance
              - address_variable: vpn0_ipv4_route1_nexthop2_ip
                distance_variable: vpn0_ipv4_route1_nexthop2_distance
```

Example-2 : In the below example , VPN template for Service VPN is configured.
vpn_id is set to 10 and variables are configured for two dns servers within service vpn. OMP routes are advertised to BGP as part of below configuration.

```yaml
sdwan:
  edge_feature_templates:
    vpn_templates:
      - name: SERVICE_VPN10
        description: Service VPN10 Template
        ipv4_primary_dns_server_variable: vpn0_dns_primary
        ipv4_secondary_dns_server_variable: vpn0_dns_secondary
        vpn_name: SERVICE_VPN10
        vpn_id: 10
        omp_advertise_ipv4_routes:
          - protocol: bgp
```


