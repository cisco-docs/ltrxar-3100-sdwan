# SD-WAN Support Matrix

This table provides an overview of which object is supported in combination with which tool.

* **Python** refers to the ability to deploy the object using the Python based solution
* **Terraform** refers to the ability to deploy the object using Terraform
* **Reverse** refers to the ability to generate YAML files from JSON configuration

### Feature Templates

<span style="display: inline-block; width:200px">Description</span> | Python | Terraform | Reverse
---|---|---|---
[cEdge AAA](./sdwan/feature_templates/cedge_aaa.md) | :material-check: | :material-check: | :material-check:
[cEdge Global](./sdwan/feature_templates/cedge_global.md) | :material-check: | :material-check: | :material-check:
[Cisco Banner](./sdwan/feature_templates/cisco_banner.md) | :material-check: | :material-check: | :material-check:
[Cisco BFD](./sdwan/feature_templates/cisco_bfd.md) | :material-check: | :material-check: | :material-check:
[Cisco BGP](./sdwan/feature_templates/cisco_bgp.md) | :material-check: | :material-check: | :material-check:
[Cisco DHCP Server](./sdwan/feature_templates/cisco_dhcp_server.md) | :material-check: | :material-check: | :material-check:
[Cisco Logging](./sdwan/feature_templates/cisco_logging.md) | :material-check: | :material-check: | :material-check:
[Cisco NTP](./sdwan/feature_templates/cisco_ntp.md) | :material-check: | :material-check: | :material-check:
[Cisco OMP](./sdwan/feature_templates/cisco_omp.md) | :material-check: | :material-check: | :material-check:
[Cisco OSPF](./sdwan/feature_templates/cisco_ospf.md) | :material-check: |  | :material-check:
[Cisco Secure Internet Gateway](./sdwan/feature_templates/cisco_secure_internet_gateway.md) | :material-check: | | :material-check:
[Cisco Security](./sdwan/feature_templates/cisco_security.md) | :material-check: | :material-check: | :material-check:
[Cisco SIG Credentials](./sdwan/feature_templates/cisco_sig_credentials.md) | :material-check: | :material-check: | :material-check:
[Cisco SNMP](./sdwan/feature_templates/cisco_snmp.md) | :material-check: | :material-check: | :material-check:
[Cisco System](./sdwan/feature_templates/cisco_system.md) | :material-check: | :material-check: | :material-check:
[Cisco ThousandEyes Agent](./sdwan/feature_templates/cisco_thousandeyes.md) | :material-check: | :material-check: | :material-check:
[Cisco VPN](./sdwan/feature_templates/cisco_vpn.md) | :material-check: | :material-check: | :material-check:
[Cisco VPN Interface](./sdwan/feature_templates/cisco_vpn_interface.md) | :material-check: | :material-check: | :material-check:
[Cisco VPN Interface IPSec](./sdwan/feature_templates/cisco_vpn_interface_ipsec.md) | :material-check: | | :material-check:
[CLI Template](./sdwan/feature_templates/cli_template.md) | :material-check: | :material-check: | :material-check:

### Device Templates

<span style="display: inline-block; width:200px">Description</span> | Python | Terraform | Reverse
---|---|---|---
[Device Template](./sdwan/edge_device_templates/device_template.md) | :material-check: | :material-check: | :material-check:

### Policy Objects

<span style="display: inline-block; width:200px">Description</span> | Python | Terraform | Reverse
---|---|---|---
[App Probe Class](./sdwan/policy_objects/app_probe_class.md) | | |
[Application List](./sdwan/policy_objects/application_list.md) | | |
[AS Path List](./sdwan/policy_objects/as_path_list.md) | | |
[Class Map](./sdwan/policy_objects/class_map.md) | | |
[Color List](./sdwan/policy_objects/color_list.md) | | |
[Expanded Community List](./sdwan/policy_objects/expanded_community_list.md) | | |
[Extended Community List](./sdwan/policy_objects/extended_community_list.md) | | |
[IPv4 Data Prefix List](./sdwan/policy_objects/ipv4_data_prefix_list.md) | | |
[IPv4 Prefix List](./sdwan/policy_objects/ipv4_prefix_list.md) | | |
[IPv6 Data Prefix List](./sdwan/policy_objects/ipv6_data_prefix_list.md) | | |
[IPv6 Prefix List](./sdwan/policy_objects/ipv6_prefix_list.md) | | |
[Mirror List](./sdwan/policy_objects/mirror_list.md) | | |
[Policer](./sdwan/policy_objects/policer.md) | | |
[Preferred Color Group](./sdwan/policy_objects/preferred_color_group.md) | | |
[Region List](./sdwan/policy_objects/region_list.md) | | |
[Site List](./sdwan/policy_objects/site_list.md) | | |
[SLA Class](./sdwan/policy_objects/sla_class.md) | | |
[Standard Community List](./sdwan/policy_objects/standard_community_list.md) | | |
[TLOC List](./sdwan/policy_objects/tloc_list.md) | | |
[VPN List](./sdwan/policy_objects/vpn_list.md) | | |
[Zones](./sdwan/policy_objects/zones.md) | | |
[FQDN List](./sdwan/policy_objects/fqdn_list.md) | | |
[Local Application List](./sdwan/policy_objects/local_application_list.md) | | |

### Localized Policies

<span style="display: inline-block; width:200px">Description</span> | Python | Terraform | Reverse
---|---|---|---
[ACL Definition](./sdwan/localized_policies/acl_definition.md) | :material-check: | :material-check: | :material-check:
[Device Access Policy Definition](./sdwan/localized_policies/device_access_policy_definition.md) | :material-check: | :material-check: | :material-check:
[QoS Map Definition](./sdwan/localized_policies/qos_map_definition.md) | :material-check: | :material-check: | :material-check:
[Rewrite Rule Definition](./sdwan/localized_policies/rewrite_rule_definition.md) | :material-check: | :material-check: | :material-check:
[vEdge Route Definition](./sdwan/localized_policies/vedge_route_definition.md) | :material-check: | :material-check: | :material-check:
[Feature Policy](./sdwan/localized_policies/feature_policy.md) | :material-check: | :material-check: | :material-check:

### Centralized Policies

<span style="display: inline-block; width:200px">Description</span> | Python | Terraform | Reverse
---|---|---|---
[Hub and Spoke Topology Definition](./sdwan/centralized_policies/hubandspoke_definition.md) | :material-check: | :material-check: | :material-check:
[Mesh Topology Definition](./sdwan/centralized_policies/mesh_definition.md) | :material-check: | :material-check: | :material-check:
[Custom Control Topology Definition](./sdwan/centralized_policies/custom_control_definition.md) | :material-check: | :material-check: | :material-check:
[VPN Membership Definition](./sdwan/centralized_policies/vpn_membership_definition.md) | :material-check: | :material-check: | :material-check:
[Application Aware Routing Definition](./sdwan/centralized_policies/application_aware_routing.md) | :material-check: | :material-check: | :material-check:
[Traffic Data Service Chaining Definition](./sdwan/centralized_policies/traffic_data_service_chaining.md) | :material-check: | :material-check: | :material-check:
[Traffic Data QOS Definition](./sdwan/centralized_policies/traffic_data_qos.md) | :material-check: | :material-check: | :material-check:
[Traffic Data Application Firewall Definition](./sdwan/centralized_policies/traffic_data_application_firewall.md) | :material-check: | :material-check: | :material-check:
[Traffic Data Traffic Engineering Definition](./sdwan/centralized_policies/traffic_data_traffic_engineering.md) | :material-check: | :material-check: | :material-check:
[Traffic Data Custom Definition](./sdwan/centralized_policies/traffic_data_custom.md) | :material-check: | :material-check: | :material-check:
[Cflowd Definition](./sdwan/centralized_policies/cflowd_policy.md) | :material-check: | :material-check: | :material-check:
[Feature Policy](./sdwan/centralized_policies/feature_policy.md) | :material-check: | :material-check: | :material-check:
[CLI Policy](./sdwan/centralized_policies/cli_policy.md) | :material-check: | :material-check: | :material-check:
[Activation](./sdwan/centralized_policies/activation.md) | :material-check: | :material-check: | :material-check:

### Security Policies

<span style="display: inline-block; width:200px">Description</span> | Python | Terraform | Reverse
---|---|---|---
[Zone based Firewall Definition](./sdwan/security_policies/zone_based_firewall_definition.md) | :material-check: | :material-check: | :material-check:
[Feature Policy](./sdwan/security_policies/fature_policy.md) | :material-check: | :material-check: | :material-check:
### Sites

<span style="display: inline-block; width:200px">Description</span> | Python | Terraform | Reverse
---|---|---|---
[Site](./sdwan/sites/site.md) | :material-check: | :material-check: | :material-check:
