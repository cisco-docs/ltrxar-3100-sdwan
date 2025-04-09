# IPv4 Access Control List Definition

Access lists configured through localized data policy are called explicit ACLs. Explicit ACLs can be applied to any interface in any VPN on the device. It can be used to filter, classify, mark traffic.

{{ doc_gen }}

### Examples

Example-1: This example show how to classify traffic based on DSCP marking.

```yaml
sdwan:
  localized_policies:
    definitions:
      ipv4_access_control_lists:
        - name: ACL-TLOCEXT-DSCP
          description: "Set traffic class based on DSCP"
          default_action: accept
          sequences:
            - id: 10
              name: Voice traffic
              base_action: accept
              match_criterias:
                dscp: 46
              actions:
                class: CLASS-REALTIME
                counter_name: 10-CLASS-REALTIME
            - id: 20
              name: Video traffic
              base_action: accept
              match_criterias:
                dscp: 34
              actions:
                class: CLASS-VIDEO
                counter_name: 20-CLASS-VIDEO
            - id: 30
              name: Transactional traffic
              base_action: accept
              match_criterias:
                dscp: 18
              actions:
                class: CLASS-TRANSACTIONAL
                counter_name: 30-CLASS-TRANSACTIONAL
            - id: 40
              name: BULK traffic
              base_action: accept
              match_criterias:
                dscp: 10
              actions:
                class: CLASS-BULK
                counter_name: 40-CLASS-BULK
```

Example-2: This example shows how to secure interface where traffic from Guest users is received.

```yaml
sdwan:
  localized_policies:
    definitions:
      ipv4_access_control_lists:
        - name: ACL-GUEST-IN
          description: "Secure interface towards Guest users"
          default_action: accept
          sequences:
            - id: 10
              name: DHCP
              base_action: accept
              match_criterias:
                protocols:
                  - 17
                source_ports:
                  - 68
                destination_ports:
                  - 67
              actions:
                counter_name: 10-DHCP
            - id: 20
              name: Guest Portal
              base_action: accept
              match_criterias:
                protocols:
                  - 6
                destination_data_prefix_list: DPL-ISE-GUEST
                destination_ports:
                  - 443
              actions:
                counter_name: 20-GUEST-PORTAL
            - id: 30
              name: DNS
              base_action: accept
              match_criterias:
                protocols:
                  - 17
                destination_ports:
                  - 53
              actions:
                counter_name: 30-DNS
            - id: 40
              name: To Enterprise Traffic
              base_action: drop
              match_criterias:
                destination_data_prefix_list: DPL-RFC1918
              actions:
                counter_name: 40-ENTERPRISE
```