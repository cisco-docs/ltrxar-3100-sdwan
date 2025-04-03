# Transport Management VPN Feature

Configure out of band management VPN (VPN 512) and its' settings.

{{ doc_gen }}

### Examples

Example-1: The example below demonstrates how to configure the management_vpn feature within a transport profile. It sets DNS addresses as global values, meaning they will be the same for all devices attached to a configuration group that contains this profile. Additionally, it includes one IPv4 static default route, where the next hop is defined as a variable. The value for this variable will be provided when a device is attached to a configuration group that contains this profile.

```yaml
sdwan:
  feature_profiles:
    transport_profiles:
      - name: transport1
        management_vpn:
          name: management_vpn
          ipv4_primary_dns_address: 1.1.1.1
          ipv4_secondary_dns_address: 1.0.0.1
          ipv4_static_routes:
            - network_address: 0.0.0.0
              subnet_mask: 0.0.0.0
              next_hops:
                - address_variable: vpn512_default_gateway
```
