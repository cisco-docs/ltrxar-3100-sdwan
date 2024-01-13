# IPv4 Access Control List Definition

Access lists configured through localized data policy are called explicit ACLs. Explicit ACLs can be applied to any interface in any VPN on the device.

{{ doc_gen }}

### Examples

```yaml
sdwan:
  localized_policies:
    definitions:
      ipv4_access_control_lists:
        - name: ACL-TLOCEXT-DSCP
          description: "Set traffic class based on DSCP or port"
          default_action: accept
          sequences:
            - id: 10
              name: QoS-ACL
              base_action: accept
              match_criterias:
                dscp: 46
                source_port_ranges:
                  - from: 1000
                    to: 1050
              actions:
                class: CLASS-REALTIME
                counter_name: 10-CLASS-REALTIME
            - id: 20
              name: AF13 traffic
              base_action: accept
              match_criterias:
                source_ports:
                  - 100
                  - 240
                dscp: 14
              actions:
                class: CLASS-BUSINESS
                counter_name: 20-CLASS-BUSINESS
```
