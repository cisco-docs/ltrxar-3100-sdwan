# Configuration Group

A configuration group is a logical grouping of features or configurations that can be applied to one or more devices in the network managed by Cisco Catalyst SD-WAN. You can define and customize this grouping based on your business needs.

{{ doc_gen }}

### Examples

Example-1: The example below defines a single device configuration group named branch_type1 and assignes service, system, and transport profiles.

```yaml
sdwan:
  configuration_groups:
    - name: branch_type1
      description: configuration group for branch with single router and dual inet transport
      service_profile: service_with_ospf
      system_profile: system_global
      transport_profile: transport_dual_inet
```

Example-2: The example below demonstrates how to define a dual device configuration group and assign service, system and transport feature profiles for this configuration group. The dual device configuration group defines "primary_router" and "secondary_router" tag (dual device configuration group always requires two tags to be defined). It also specifies that devices with the "primary_router" tag will use the "inet_tloc" feature, while devices with the "secondary_router" tag will use the "mpls_tloc" feature. Any features not explicitly specified will be used by routers with either tag.

Note that for dual device configuration group device_tags -> features section, only names for the following feature types are supported:

- lan/vpn
- lan/vpn/interface/ethernet
- lan/vpn/interface/ipsec
- lan/vpn/interface/svi
- routing/bgp
- routing/ospf
- wan/vpn/interface/cellular
- wan/vpn/interface/ethernet
- wan/vpn/interface/gre
- wan/vpn/interface/ipsec
- wan/vpn/interface/serial

```yaml
sdwan:
  configuration_groups:
    - name: branch_type2
      description: configuration group for branch with dual routers
      cli_profile: cli1
      other_profile: other1
      policy_object_profile: policy_objects
      service_profile: service1
      system_profile: system1
      transport_profile: transport1
      device_tags:
        - name: primary-router
          features:
            - inet_tloc
        - name: secondary-router
          features:
            - mpls_tloc
```
