# IPv4 Device Access Policy Definition

The control plane of Cisco WAN Edge devices process the data traffic for local services like, SSH and SNMP, from a set of sources. It is important to protect the CPU from device access traffic by applying the filter to avoid malicious traffic.

Access policies define the rules that traffic must meet to pass through an interface.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  localized_policies:
    definitions:
      ipv6_device_access_policies:
        - name: ACL-DEVICEACCESSPOLICY-01
          description: "SSH and SNMP access control"
          default_action: drop
          sequences:
            - id: 10
              base_action: accept
              match_criterias:
                source_ports:
                  - 1000
                  - 2001
                destination_data_prefix_list: SNMP-SERVERS
                destination_port: 161
              counter_name: SEQ10-SNMP
```
