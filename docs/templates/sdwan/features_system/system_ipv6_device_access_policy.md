# System IPv6 Device Access Policy Feature

The control plane of Cisco WAN Edge devices process the data traffic for local services like, SSH and SNMP, from a set of sources. It is important to protect the CPU from device access traffic by applying the filter to avoid malicious traffic.

Device access policy defines the rules that traffic must meet to reach the control plane.

{{ doc_gen }}

### Examples

The example shows how to configure IPv6 device access policy that allows SSH traffic (port 22) with source IP from "jumpservers" prefix-list, source ports either 1000 or 2001. The rest of the management traffic is dropped with default action drop statement.

```yaml
sdwan:
  feature_profiles:
    system_profiles:
      - name: system
        ipv6_device_access_policy:
          name: ipv6_device_access_policy
          description: basic ipv6 device access policy
          default_action: drop
          sequences:
            - base_action: accept
              match_entries:
                source_data_prefix_list: jumpservers
                source_ports:
                  - 1000
                  - 2001
                destination_port: 22
```
